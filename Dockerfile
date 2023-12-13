FROM ls1tum/artemis-maven-template:java17-18

COPY ./tests /exercise
COPY benchmark.sh repo.txt /opt/

RUN chmod +x /opt/benchmark.sh
ENTRYPOINT ["/bin/bash", "-c", "cd /opt && ./benchmark.sh"]