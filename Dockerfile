FROM rocker/r-ver:4.1.2

WORKDIR /home

RUN apt-get update -qq \
    && apt-get -y --no-install-recommends install \
    liblzma-dev \
    libbz2-dev \
    clang  \
    ccache \
    default-jdk \
    default-jre \
    && R CMD javareconf \
    && install2.r --error \
        telegram.bot \
        xlsx

COPY bot_na_R.Rproj bot_na_R.Rproj

COPY filters.R filters.R

COPY functions.R functions.R

COPY main.R main.R

COPY methods.R methods.R

COPY ./Practice_work /Practice_work

CMD R -e "source('/home/main.R')"
