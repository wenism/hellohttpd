FROM httpd:2.4
COPY ./entrypoint.sh /
COPY ./index.html /usr/local/apache2/htdocs/
ENTRYPOINT [ "/entrypoint.sh" ]