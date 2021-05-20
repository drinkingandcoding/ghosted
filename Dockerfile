FROM barichello/godot-ci:3.3

WORKDIR /ghosted

RUN mkdir -v -p ~/.local/share/godot/templates
RUN mkdir -v -p build/web ~/.local/share/godot/templates

ADD . .
RUN godot -v --export "HTML5" ./build/web/index.html

WORKDIR /ghosted/build/web

CMD ["python", "-m", "SimpleHTTPServer", "7777"]

