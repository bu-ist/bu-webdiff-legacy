#!/usr/bin/env python
from selenium import webdriver
import argparse
import os
import urllib

def url_to_filename(url):
	filename = url.replace('http://', '')
	filename = filename.replace('/', '%2F')
	return filename

def main():
	# command line args
	parser = argparse.ArgumentParser(description='Load a series of URLs and \
	take a screenshot.')
	
	parser.add_argument('runname', help='the name for this run')
	
	parser.add_argument('--urls', default='urls.txt', help='the filename \
	containing the list of URLs to load')
	
	args = parser.parse_args()
	
	if not os.path.exists(args.runname):
	    os.makedirs(args.runname)
	
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
		filename = "%s/%s.png" % (args.runname, urllib.quote_plus(url))
		print '[-] %s' % (url)
		
		try:
			browser.save_screenshot(filename)
		except:
			print '[!] ERROR %s' % (url)

	browser.quit()

if __name__ == "__main__":
		main()
