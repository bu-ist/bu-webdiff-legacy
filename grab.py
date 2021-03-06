#!/usr/bin/env python
from __future__ import print_function
from selenium import webdriver
from pyvirtualdisplay import Display
import argparse
import os
import urllib
import sys
import time


def url_to_filename(url):
    filename = url.replace('http://', '')
    filename = filename.replace('/', '%2F')
    return filename

def chunks(l, n):
    """ create an array of n-length arrays with list broken up equally """
    for i in range(0, len(l), n):
        yield l[i:i+n]

def main():
    # command line args
    parser = argparse.ArgumentParser(description='Load a series of URLs and \
                                     take a screenshot.')

    parser.add_argument('directory', help='directory to save images to')

    parser.add_argument('--urls', default='urls.txt', help='the filename \
                        containing the list of URLs to load')

    parser.add_argument('--browser', default='firefox', help='browser name \
                        must be supported by selenium \
                        (options: firefox, phantomjs')

    parser.add_argument('--per-cycle', default=100, help='determines how many \
                        urls to process with a single instance of the browser \
                        before restarting')

    parser.add_argument('--virtual-display', action='store_true', help='uses \
                        a virtual display to create a remote display \
                        for SSH session')

    parser.add_argument('--verbose', action='store_true',
                        help='show extra output')

    args = parser.parse_args()

    if not os.path.exists(args.directory):
        try:
            os.mkdir(args.directory)
        except OSError as e:
            print('* Could not create directory "{0}": \
                  {1} ({2})'.format(args.directory, e.message, e.errno),
                  file=sys.stderr)
            sys.exit(1)

    if args.verbose:
        start_time = time.time()

    if args.virtual_display:
        if args.verbose:
            print("Starting virtual display.")
        display = Display(visible=0, size=(1200, 800))
        display.start()


    # load urls
    urls_list = open(args.urls).read().splitlines()
    urls_chunks = chunks(urls_list, int(args.per_cycle))

    i = 0
    for urls in urls_chunks:
        i = i+1
        if args.verbose:
            print("Launching new %s browser at chunk %s" % (args.browser, i,))

        # setup our browser
        if args.browser == 'phantomjs':
            browser = webdriver.PhantomJS()
        else:
            profile = webdriver.FirefoxProfile()

            profile.set_preference("browser.download.folderList", 2)
            # profile.set_preference("javascript.enabled", False)
            browser = webdriver.Firefox(firefox_profile=profile)


        browser.set_window_size(1200, 800)

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

    if args.virtual_display:
        if args.verbose:
            print("Stopping virtual display.")
        display.stop()

    if args.verbose:
        end_time = time.time()
        total_time = end_time-start_time
        print("Total time: %.2f seconds" % (total_time,))
        print("Speed: %.2f URLs per minute" % (len(urls_list)/total_time*60,))

if __name__ == "__main__":
    main()
