# Page Comparison Tools

The quick version:

* grab.py takes screenshots of web pages  (specified by URL in a file) with Firefox
* compare.sh compares the output of two sets of screenshots
* Selenium is required for taking the screenshots
* ImageMagick is required for comparing the screenshots

## To do

[ ] Eliminate ImageMagick requirement (PIL?)

## Setting Up

After cloning or downloading, install the required packages using [pip](https://pypi.python.org/pypi/pip). Using [virtualenv](https://pypi.python.org/pypi/virtualenv) is highly recommended.

To setup your virtualenv (once):
```bash
cd bu-webdiff
virtualenv venv
```

To use it:
```bash
source venv/bin/activate
pip install -r requirements.txt
```

## Firefox
Firefox browser is the recommended way of taking screenshots. Selenium will automatically find the Firefox installed on the machine. It is easier to set it up than Chrome. Although Selenium claims the latest version of Firefox is compatible, I've never seen it to be case. As of August 2016, Firefox 46 works with this setup.

## ImageMagick

On Mac systems, you can install ImageMagick using brew.
```bash
brew install imagemagick
```
	
## Grabbing & Comparing

1. Grab screenshots for a list of urls. To display usage:
```bash
./grab.py
```
	
2. Grab screenshots for urls listed in urls.txt and stores them in "first_run" directory:

```bash
./grab.py first_run
```

3. Grab all urls from urls.txt and stores screenshots in "second_run" directory:

```bash
./grab.py second_run
```

In between #2 and #3 could be either changing your /etc/hosts file to switch between the old and new environments or the actual launch of a new environment.

2. Once you have two sets of images, you can compare them:

```bash
./compare.sh first_run second_run
```

Ideally this will have no output. If a screenshot differs between the two runs, it will print the URL of the differing page to the screen. It's up to you to investigate the reason why the page differs. The comparison tool will save a "difference" image for any pages that differ in the current directory. You may examine this image to see if the changes are significant. Be wary of dynamic page content, such as advertisements or banners.
