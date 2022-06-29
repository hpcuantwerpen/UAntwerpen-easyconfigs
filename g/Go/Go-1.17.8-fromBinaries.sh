easyblock = 'Tarball'

name = 'Go'
version = '1.17.8'

homepage = 'https://www.golang.org'

whatis = [
    "Description: Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.",
]

description = """
Go is an open source programming language that makes it easy to build
simple, reliable, and efficient software.
"""

toolchain = SYSTEM

sources = ['%(namelower)s%(version)s.linux-amd64.tar.gz']
source_urls = ['https://storage.googleapis.com/golang/']
checksums = ['980e65a863377e69fd9b67df9d8395fd8e93858e7a24c9f55803421e453f4f99']

sanity_check_paths = {
    'files': ['bin/go', 'bin/gofmt'],
    'dirs': ['api', 'doc', 'lib', 'pkg'],
}

modextravars = {'GOROOT': '%(installdir)s'}
moduleclass = 'compiler'
