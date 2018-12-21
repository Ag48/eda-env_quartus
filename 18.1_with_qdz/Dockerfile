FROM stomoki/eda-env_emacs-verilog-mode AS building
LABEL maintainer="Tomoki Sugiura"
WORKDIR /tmp

ARG version_quartus="18.1"
ARG build_quartus="625"
ARG bin_quartus="QuartusLiteSetup-${version_quartus}.0.${build_quartus}-linux.run"
ARG lib_max10="max10-${version_quartus}.0.${build_quartus}.qdz"
# ARG lib_cyclone5="cyclone5-${version_quartus}.0.${build_quartus}.qdz"
ARG url_download_prefix="http://download.altera.com/akdlm/software/acdsinst/${version_quartus}std/${build_quartus}/ib_installers"
ARG url_download_quartus="${url_download_prefix}/${bin_quartus}"
ARG url_download_max10="${url_download_prefix}/${lib_max10}"
ARG path_install_quartus="/eda/altera_lite/${version_quartus}"

# prepare required packages
RUN yum update -y \
    && yum install -y \
      glib.i686 \
      libX11-devel.i686 \
      libXext-devel.i686 \
      libXft-devel.i686 \
      ncurses-libs.i686
ADD ${url_download_quartus} /tmp
ADD ${url_download_max10} /tmp
RUN wget -c -nv ${url_download_quartus} 
RUN chmod a+x ${bin_quartus} 
RUN ./${bin_quartus} \
  --mode unattended \
  --installdir ${path_install_quartus} \
  --unattendedmodeui none \
  --accept_eula 1
RUN rm -rf ${path_install_quartus}/uninstall

# build image
FROM stomoki/eda-env_emacs-verilog-mode:latest
COPY --from=building /eda/altera_lite /altera_lite
RUN yum update -y \
  && yum install -y \
    glibc.i686 \
    libXext-devel.i686 \
    libXft-devel.i686 \
    ncurses-libs.i686 \
  && yum groupinstall -y "X Window System" \
  && yum clean all
ENV PATH /altera_lite/18.1/quartus/bin:$PATH

# set ssh config & gen ssh-key
## gen ssh-key
RUN /etc/init.d/sshd start 
EXPOSE 22

CMD /usr/sbin/sshd -D
