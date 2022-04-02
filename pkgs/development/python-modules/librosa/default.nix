{ lib
, buildPythonPackage
, fetchPypi
, joblib
, matplotlib
, six
, scikit-learn
, decorator
, audioread
, resampy
, soundfile
, pooch
}:

buildPythonPackage rec {
  pname = "librosa";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ftXW4/RUbl48KEBpH53cVoePkUo1pQBg31/KKybUthQ=";
  };

  propagatedBuildInputs = [ joblib matplotlib six scikit-learn decorator audioread resampy soundfile pooch ];

  # No tests
  # 1. Internet connection is required
  # 2. Got error "module 'librosa' has no attribute 'version'"
  doCheck = false;

  # check that import works, this allows to capture errors like https://github.com/librosa/librosa/issues/1160
  pythonImportsCheck = [ "librosa" ];

  meta = with lib; {
    description = "Python module for audio and music processing";
    homepage = "http://librosa.github.io/";
    license = licenses.isc;
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };

}
