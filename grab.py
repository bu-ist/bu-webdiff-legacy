#!/usr/bin/env python
from __future__ import print_function
from selenium import webdriver
import argparse
import os
import urllib
import sys


def url_to_filename(url):
    filename = url.replace('http://', '')
    filename = filename.replace('/', '%2F')
    return filename


def main():
    # command line args
    parser = argparse.ArgumentParser(description='Load a series of URLs and \
                                     take a screenshot.')

    parser.add_argument('directory', help='directory to save images to')

    parser.add_argument('--urls', default='urls.txt', help='the filename \
                        containing the list of URLs to load')

    args = parser.parse_args()

    if not os.path.exists(args.directory):
        try:
            os.mkdir(args.directory)
        except OSError as e:
            print('* Could not create directory "{0}": \
                  {1} ({2})'.format(args.directory, e.message, e.errno),
                  file=sys.stderr)
            sys.exit(1)

    # setup our browser
    profile = webdriver.FirefoxProfile()

    profile.set_preference("browser.download.folderList", 2)
    # profile.set_preference("javascript.enabled", False)

    browser = webdriver.Firefox(firefox_profile=profile)
    browser.set_window_size(1200, 800)

    # load urls
    urls = open(args.urls).read().splitlines()

    # grab screenshots
    for url in urls:
        browser.get(url)
        filename = os.path.join(args.directory,
                                urllib.quote_plus(url) + '.png')
        print(url)

        try:
            browser.save_screenshot(filename)
        except:
            print('* ERROR {0}'.format(url))

    browser.quit()

if __name__ == "__main__":
    main()
