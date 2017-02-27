FROM debian:latest
MAINTAINER Luís Sousa <llsousa@gmail.com>

# Inspired on the work of Charo Nuguid available at
# https://github.com/charonuguid/docker-latex for reference

# Inform debian that is running in non interactive mode
ENV DEBIAN_FRONTEND noninteractive

# Base packages
RUN apt-get update \
	&& apt-get -u dist-upgrade -y \
	&& apt-get install -y \
			apt-utils \
			dialog \
	    	less \
	    	vim \
	&& apt-get clean

# Texlive dependencies
RUN apt-get update \
	&& apt-get install -y \
			python \
			perl \
			wget \
	&& apt-get clean

# Texlive environment
ENV PATH /usr/local/texlive/latest/bin/x86_64-linux:$PATH
ENV INFOPATH /usr/local/texlive/latest/texmf-dist/doc/info
ENV MANPATH /usr/local/texlive/latest/texmf-dist/doc/man

# Texlive installation profile
COPY texlive.profile /root/

# Texlive installation
RUN cd /root \
	# Hack for Windows platform
	&& sed -i 's/\r//g' texlive.profile \
	&& wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
	&& tar -xzf install-tl-unx.tar.gz \
	&& cd install-tl-*/ \
	&& ./install-tl --profile=/root/texlive.profile \
	&& rm -rf /root/install-tl-*

# Install LaTeX packages for novathesis template
RUN tlmgr install \
			kpfonts \
			biblatex \
			logreq \
			xifthen \
			ifmtarg \
			csquotes \
			etoolbox \
			xstring \
			soul \
			mathalfa \
			glossaries \
			mfirstuc \
			xfor \
			datatool \
			substr \
			tracklang \
			paralist \
			todonotes \
			lipsum \
			supertabular \
			glossaries-portuges \
			glossaries-english \
			biblatex-apa

# Map to src
VOLUME /src
WORKDIR /src