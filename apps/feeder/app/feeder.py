#!/usr/bin/python
import feedparser
import time
from feedgen.feed import FeedGenerator
import os
import sys
from http.server import HTTPServer, SimpleHTTPRequestHandler
from timeloop import Timeloop
from datetime import timedelta
import logging

mandatory_vars = [
    'FEED_ITEMS',
    'FEED_ID',
    'FEED_TITLE',
    'FEED_SUBTITLE',
    'FEED_AUTHOR_NAME',
    'FEED_AUTHOR_EMAIL',
    'FEED_LINK_ALTERNATE',
    'FEED_LINK_SELF',
    'FEED_UPDATE_INTERVAL'
]

for key_value in mandatory_vars:
    try:
        if os.environ[key_value]:
            continue
    except KeyError:
        print(key_value, 'environment variable is not set.')
        sys.exit(1)

VALID_LEVELS = ["DEBUG", "INFO", "WARNING", "ERROR"]

try:
  if os.environ['DEBUG_LEVEL']:
    DEBUG_LEVEL=os.environ['DEBUG_LEVEL'].upper()
except KeyError:
  DEBUG_LEVEL="INFO"

if DEBUG_LEVEL not in VALID_LEVELS:
  print ("ERROR: Invalid debug level {}, fallback to INFO.".format(DEBUG_LEVEL))
  DEBUG_LEVEL="INFO"

logger = logging.getLogger(' feeder ')
ch = logging.StreamHandler(sys.stdout)
ch.setLevel(DEBUG_LEVEL)
formatter = logging.Formatter('[%(asctime)s] [%(name)s] [%(levelname)s] %(message)s')
ch.setFormatter(formatter)
logger.addHandler(ch)
logger.setLevel(DEBUG_LEVEL)

logger.info("Update interval ist set to {} minutes".format(os.environ['FEED_UPDATE_INTERVAL']))

tl = Timeloop()
@tl.job(interval=timedelta(minutes=int(os.environ['FEED_UPDATE_INTERVAL'])))
def update_feeds():
  logger.info('Start parsing feeds')
  sources = list(set(open('/app/config/urls.txt', 'r').readlines()))
  fullList = []
  for url in sources:
    logger.debug("Parsing {}".format(url))
    feed = feedparser.parse(url)
    for item in feed['items']:
      logger.debug("Read item {}".format(item['title']))
      fullList.append(item)
  fullList.sort(key=lambda item: item['updated_parsed'], reverse=True)
  outList = fullList [0:int(os.environ['FEED_ITEMS'])]
  logger.debug('Finished parsing feeds')

  logger.debug('Starting feed generation')
  fg = FeedGenerator()
  fg.id(os.environ['FEED_ID'])
  fg.title(os.environ['FEED_TITLE'])
  fg.subtitle(os.environ['FEED_SUBTITLE'])
  fg.author( {'name':os.environ['FEED_AUTHOR_NAME'], 'email':os.environ['FEED_AUTHOR_EMAIL']} )
  fg.link( href=os.environ['FEED_LINK_ALTERNATE'],rel='alternate' )
  fg.link( href=os.environ['FEED_LINK_SELF'], rel='self' )
  fg.language('en')
  known_titles = set()
  for item in outList:
    logger.debug("Parse item {}".format(item['title']))
    if item["title"] in known_titles:
      logger.debug("Title already exists in feed: {}".format(item['title']))
      continue
    logger.debug("Adding item to feed: {}".format(item['title']))
    known_titles.add(item["title"])
    fe = fg.add_entry(order='append')
    fe.id(item['id'])
    fe.title(item['title'])
    fe.link(href=item['link'])
    fe.updated(item['updated'])
    # add author if present in original
    if('author' in item):
      fe.author(name=item['author'])
    if('summary' in item):
      # If the summary contains HTML code, set its type.
      summary_type = 'html' if '<' in item['summary'] else None
      fe.summary(summary=item['summary'], type=summary_type)
    if('tags' in item):
      for tag in item.tags:
        fe.category(term=tag.term)
    if('content' in item):
      fe.content(content=content.value, type='html')
  fg.atom_file('feed.xml')
  logger.info('Finished feed generation')

update_feeds()

tl.start(block=True)