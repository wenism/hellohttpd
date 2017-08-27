FROM httpd:2.4
COPY ./entrypoint.sh /tmp
COPY ./index.html /usr/local/apache2/htdocs/
ENTRYPOINT [ "./tmp/entrypoint.sh" ]