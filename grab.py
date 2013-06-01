from selenium import webdriver
import argparse
import os
import urllib

def url_to_filename(url):
	filename = url.replace('http://', '')
	filename = filename.replace('/', '#')
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
	browser = webdriver.Firefox()
	browser.set_window_size(1200, 800)
	
	# load urls
	urls = open(args.urls).read().splitlines()

	# grab screenshots
	for url in urls:
		browser.get(url)
		filename = "%s/%s.png" % (args.runname, urllib.quote_plus(url))
		print 'Grabbing %s to %s' % (url, filename)
		
		try:
			browser.save_screenshot(filename)
		except:
			print 'There was a problem grabbing %s' % (url)

	browser.quit()

if __name__ == "__main__":
		main()
