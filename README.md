# Page Comparison Tools

The quick version:

* grab.py takes screenshots of web pages  (specified by URL in a file)
* compare.sh compares the output of two sets of screenshots
* Selenium is required for taking the screenshots
* ImageMagick is required for comparing the screenshots

## Setting Up

After cloning or downloading, install the required packages using pip. Using [virtualenv](https://pypi.python.org/pypi/virtualenv) is highly recommended.

	$ cd buwp-smoketests
	$ virtualenv .
	$ source bin/activate
	$ pip install -r requirements.txt

## ImageMagick

Download [libpng (1.6.2 used)](http://www.libpng.org/pub/png/libpng.html) and [ImageMagick (6.8.5 used)](http://www.imagemagick.org/download/) and install from source:

	$ tar zxvf libpng-1.6.2.tar.gz
	$ cd libpng-1.6.2
	$ ./configure
	$ make
	$ sudo make install
	
	$ tar zxvf ImageMagick-6.8.5-10.tar.gz
	$ cd ImageMagick
	$ ./configure
	$ make
	$ sudo make install
	
## Grabbing & Comparing

1. Grab screenshots for a list of urls:

	$ python grab.py # will display usage
	$ python grab.py first_run # grabs all urls from urls.txt and stores screenshots in "first_run" directory
	...
	$ python grab.py second_run # grabs all urls from urls.txt and stores screenshots in "second_run" directory

That "…" between the first and second run could be either changing your hosts.txt file to switch between the old and new environments or the actual launch of a new environment.

2. Once you have two sets of images, you can compare them:

	$ ./compare.sh first_run second_run

Ideally this will have no output. If a screenshot differs between the two runs, it will print the URL of the differing page to the screen. It's up to you to investigate the reason why the page differs. The comparison tool will save a "difference" image for any pages that differ in the current directory. You may examine this image to see if the changes are significant. Be wary of dynamic page content, such as advertisements or banners.
