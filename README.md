# Page Comparison Tools

The quick version:

* grab.py takes screenshots of web pages  (specified by URL in a file) with Firefox
* compare.sh compares the output of two sets of screenshots
* Selenium is required for taking the screenshots
* ImageMagick is required for comparing the screenshots

## To do

[ ] Eliminate ImageMagick requirement (PIL?)

## Setting Up

* If you don't already have [Brew](http://brew.sh/), install it. This will help with managing your dependencies.
* If you don't have Selenium install it using `brew install selenium-server-standalone`.
* If you don't have ImageMagick install it using `brew install imagemagick`.
* Now's a good time to update Python too, which will take care of grabbing pip for you. Do this using `brew install python`.

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

## Browsers

### Firefox
Firefox browser is the recommended way of taking screenshots. Selenium will automatically find the Firefox installed on the machine. It is easier to set it up than Chrome. Although Selenium claims the latest version of Firefox is compatible, I've never seen it to be case. As of August 2016, [Firefox 46](https://ftp.mozilla.org/pub/firefox/releases/46.0/mac/en-US/) works with this setup.

This script will try to use your default version of Firefox. The easiest way I've found to get around this is to have two versions set up. When you download 46, drag it into Applications just like you normally would, but do not replace your current Firefox install - keep both. That will name 46 "Firefox 2". Rename your current version of Firefox to Firefox-current, and keep that in your dock. Rename 46 (Firefox 2) to Firefox.

## Lists of URLs

### WordPress

It is easy to generate a list of URLs for a WordPress site through wp-cli.

```bash
# List post types registered on a site
wp --url=www.bu.edu/met/ post-type list
# List permalinks for the found post types.
wp --url=www.bu.edu/met/ post list --fields=url --post_type=post,page --post_status=publish --format=csv | tail -n +2
```

### Google Analytics

To get a list of popular sites or URLs, check the Google Analytics account under Reports > Behavior > Content Drilldown and use Export into CSV.

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

## Wordpress: Testing a Sandbox Site Against a Live Site

You may wish to run a comparison of a sandbox version of a site and a live version of the same site. For example, your sandbox version of the site might be running a newer version of Wordpress that has not yet been deployed on the live version of the site. 

Before beginning, be sure to have Firefox 46.0 installed, as this is the browser that webdiff is expecting to use.

1. Create a local clone of the live site in your sandbox.

2. Install the "List All URLs" plugin (either in your cloned site, or globally—that is, in your cloned sites' root site—depending on how many sites you will be comparing). Then, within the cloned site, go to Settings-->List All URLs, select the "All URLs" radio button, and click submit.

3. Copy and paste the complete list of URLs into bu-webdiff/urls.txt, competely replacing anything that may already be there.

4. Webdiff grabs screenshots for these URLs and stores them in a newly created "first_run" directory:

```bash
./grab.py first_run
```

5. Reopen urls.txt and use your text editor's find and replace function to change the first part of each of the links to the root of the live site rather than the sandbox (e.g., http://www.bu.edu/ instead of http://mysandbox.com/).

6. Webdiff grabs screenshots for all urls from urls.txt (now reflecting the live site) and stores these in a newly created "second_run" directory:

```bash
./grab.py second_run
```

7. Webdiff names the files in the two folders according to their URLs, with certain characters escaped. These file names must be identical, however, for webdiff to compare a screenshot of one page to that of another. Use find and replace / batch renaming to transform the first part of each filename so that files in first_run and second_run have identical names (i.e., each file in first_run matches a single, identically named file in second_run).

8. Once you have two sets of images with matching file names, webdiff can compare them:

```bash
./compare.sh first_run second_run
```


