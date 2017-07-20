package = 'ffi-reloadable'
version = 'scm-1'

source  = {
    url    = 'git://github.com/moonlibs/ffi-reloadable.git';
    branch = 'master';
}

description = {
    summary  = "Binary tools";
    detailed = "Binary tools";
    homepage = 'https://github.com/moonlibs/ffi-reloadable.git';
    license  = 'Artistic';
    maintainer = "Mons Anderson <mons@cpan.org>";
}

dependencies = {
    'lua >= 5.1';
}

build = {
    type = 'builtin',
    modules = {
        ['ffi.reloadable'] = 'ffi/reloadable.lua';
    }
}