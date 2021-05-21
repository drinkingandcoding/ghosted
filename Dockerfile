FROM barichello/godot-ci:3.3

RUN useradd -ms /bin/bash node

WORKDIR /ghosted

RUN mkdir -v -p ~/.local/share/godot/templates
RUN mkdir -v -p build/web ~/.local/share/godot/templates


ADD . .
# RUN chown -R node:node /ghosted
RUN godot -v --export "HTML5" ./build/web/index.html

COPY scores.json /ghosted/build/web/scores.json
WORKDIR /ghosted/build/web

CMD ["python", "-m", "SimpleHTTPServer", "7777"]

