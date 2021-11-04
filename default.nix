let
    pkgs = import <nixpkgs> {};
in rec {
    vecmem = pkgs.stdenv.mkDerivation rec {
        pname = "vecmem";
        version = "0.5.0";

        src = fetchGit {
            url = "https://github.com/acts-project/vecmem.git";
            ref = "refs/tags/v${version}";
        };

        nativeBuildInputs = [
            pkgs.cmake
        ];

        cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Release"
            "-DVECMEM_BUILD_TESTING=Off"
            "-DVECMEM_BUILD_CUDA_LIBRARY=Off"
        ];
    };

    algebra = pkgs.stdenv.mkDerivation rec {
        pname = "algebra";
        version = "0.2.0";

        src = fetchGit {
            url = "https://github.com/stephenswat/algebra-plugins.git";
            ref = "main";
        };

        nativeBuildInputs = [
            pkgs.cmake
        ];

        buildInputs = [
            vecmem
        ];

        cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Release"
            "-DALGEBRA_PLUGIN_BUILD_TESTING=Off"
            "-DALGEBRA_PLUGIN_SETUP_GOOGLETEST=Off"
            # TODO Why will these not work???
            "-DALGEBRA_PLUGIN_INCLUDE_EIGEN=Off"
            "-DALGEBRA_PLUGIN_INCLUDE_SMATRIX=Off"
            "-DALGEBRA_PLUGIN_INCLUDE_VC=Off"
            "-DALGEBRA_PLUGIN_INCLUDE_VECMEM=Off"
        ];
    };

    dfelibs = pkgs.stdenv.mkDerivation rec {
        pname = "dfelibs";
        version = "0.0.0";

        src = fetchGit {
            url = "https://github.com/acts-project/dfelibs.git";
            ref = "master";
            rev = "2160cefb88cbaea9bb023bef6c1ba6549c139cf6";
        };

        nativeBuildInputs = [
            pkgs.cmake
        ];

        buildInputs = [
            pkgs.boost175
            pkgs.root
        ];

        cmakeFlags = [
            "-Ddfelibs_ENABLE_INSTALL=On"
            "-Ddfelibs_BUILD_EXAMPLES=Off"
            "-Ddfelibs_BUILD_UNITTESTS=Off"
        ];
    };

    detray = pkgs.stdenv.mkDerivation rec {
        pname = "detray";
        version = "0.0.1";

        src = fetchGit {
            url = "https://github.com/acts-project/detray.git";
            ref = "main";
        };

        nativeBuildInputs = [
            pkgs.cmake
        ];

        buildInputs = [
            pkgs.eigen
            pkgs.vc
            dfelibs
            vecmem
            algebra
        ];

        cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Release"
            "-DDETRAY_SETUP_VECMEM=On"
            "-DDETRAY_USE_SYSTEM_VECMEM=On"
            "-DDETRAY_SETUP_ALGEBRA_PLUGINS=On"
            "-DDETRAY_USE_SYSTEM_ALGEBRA_PLUGINS=On"
            "-DDETRAY_SETUP_DFELIBS=On"
            "-DDETRAY_USE_SYSTEM_DFELIBS=On"
            # TODO Turn this on
            "-DDETRAY_SETUP_THRUST=Off"
            "-DDETRAY_SETUP_GOOGLETEST=Off"
            "-DDETRAY_SETUP_BENCHMARK=Off"
            "-DDETRAY_BENCHMARKS=Off"
        ];
    };

    acts = pkgs.stdenv.mkDerivation rec {
        pname = "acts";
        version = "14.1.0";

        src = fetchGit {
            url = "https://github.com/acts-project/acts.git";
            ref = "refs/tags/v${version}";
        };

        nativeBuildInputs = [
            pkgs.cmake
            pkgs.boost175
            pkgs.eigen
        ];

        buildInputs = [
        ];

        cmakeFlags = [
            "-DACTS_USE_SYSTEM_AUTODIFF=On"
            "-DACTS_USE_SYSTEM_NLOHMANN_JSON=On"
            "-DACTS_USE_SYSTEM_BOOST=On"
            "-DACTS_USE_SYSTEM_EIGEN3=On"

            "-DACTS_BUILD_EXAMPLES=On"
            "-DACTS_BUILD_UNITTESTS=On"
        ];
    };
}
