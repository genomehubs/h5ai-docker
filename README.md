# GenomeHubs h5ai download server deployment

```
docker run -d -p 8080:80 -v h5ai/conf:/conf -v /data/to/host:/var/www/data --name genomehubs-download h5ai-downloads
```

Directories to be indexed should be mounted as subdirectories of ``/var/www``

Files in a directory mounted to /conf will be used as follows
- ``lighttpd.conf`` overwrites ``/etc/lighttpd/lighttpd.conf`` 
- ``options.json`` overwrites ``/var/www/_h5ai/private/conf/options.json``
- ``index.html`` is copied to ``/var/www/`` and will be served in place of a directory listing for the server root
- ``Masthead.html`` is added to ``/var/www/_h5ai/private/php/pages/index.php`` as a masthead on everypage
- ``img/*`` files in this directory are copied to ``/var/www/img`` 
- ``custom.css`` is copied to ``/var/www/_h5ai/public/ext/``

