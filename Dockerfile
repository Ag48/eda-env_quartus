FROM stomoki/eda-env_emacs-verilog-mode
LABEL maintainer="Tomoki Sugiura"
WORKDIR /tmp

ARG version_quartus="16.0"
ARG build_quartus="211"
ARG bin_quartus="QuartusSetup-${version_quartus}.0.${build_quartus}-linux.run"
ARG lib_max10="max10-${version_quartus}.0.${build_quartus}.qdz"
ARG lib_cyclone5="cyclone5-${version_quartus}.0.${build_quartus}.qdz"
ARG url_download_prefix="http://download.altera.com/akdlm/software/acdsinst/${version_quartus}/${build_quartus}/ib_installers"
ARG url_bin_quartus="${url_download_prefix}/${bin_quartus}"
ARG url_lib_max10="${url_download_prefix}/${lib_max10}"
ARG url_lib_cyclone5="${url_download_prefix}/${lib_cyclone5}"
ARG url_download_quartus="http://download.altera.com/akdlm/software/acdsinst/${version_quartus}/${build_quartus}/ib_installers/${bin_quartus}"
ARG url_download_max10_lib="http://download.altera.com/akdlm/software/acdsinst/16.0/211/ib_installers/max10-16.0.0.211.qdz"
ARG path_install_quartus="/eda/altera_lite/${version_quartus}"

# for modelsim
## modelsim's url ref : https://gist.github.com/zweed4u/ecc03ade1da8c51127a5485830d7a621
RUN yum update -y \
    && yum install -y \
      glib.i686 \
      libX*.i686 \
      ncurses-libs.i686 \
    && yum groupinstall -y "X Window System" \
    && yum clean all
RUN wget --spider -nv --timeout 10 -t 1 ${url_download_quartus} \
    && wget --spider -nv --timeout 10 -t 1 ${url_download_max10_lib} \
    && wget -c -nv ${url_download_max10_lib} \
    && wget -c -nv ${url_download_quartus} \
    && chmod a+x ${bin_quartus} \
    && sync \
    && ./${bin_quartus} --mode unattended --installdir ${path_install_quartus} --unattendedmodeui none \
    && rm -f ${lib_max10} ${bin_quartus}

## for bug in ver.16.0
# RUN cd ${path_install_quartus}/modelsim_ase; ln -s linux linux_rh60
## Test bin
# RUN ${path_install_quartus}/modelsim_ase/bin/vsim -c -version
## set modelsim's path to PATH
# RUN echo "export PATH=${PATH}:/eda/intelFPGA/16.0/modelsim_ase/bin; echo 'set vsim path to PATH'" >> /etc/bashrc 
# RUN source /etc/bashrc; which vsim

# set ssh config & gen ssh-key
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
## gen ssh-key
RUN /etc/init.d/sshd start 
EXPOSE 22
# ENV "PATH=eda/intelFPGA/16.0/modelsim_ase/bin:${PATH}"

# CMD /usr/sbin/sshd -D
