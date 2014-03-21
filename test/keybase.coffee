assert = require 'assert'
keybase = require '../lib/keybase.coffee'

describe 'keybase', ->
  @timeout 10000
  it 'should verify a valid message', (done) ->
    signed = """
    -----BEGIN PGP MESSAGE-----
    Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
    Comment: GPGTools - https://gpgtools.org

    owEBOQHG/pANAwAKAQHsPMmEdS8iAcsJYgBTLA+vaGFpiQEcBAABCgAGBQJTLA+v
    AAoJEAHsPMmEdS8i+3sIAII+gg2VRdN1DO0cSWCDJQ9kFbA+9RdsSAGAJxnZIhdM
    /M7jcsh3YhxDLFRtWXbtgayKls4Bgs9tT2Zl4+bv7exXyjqsL8GUgLVwOJN1PK0R
    odsnMMf/nEraP7rEctlcJlkMXZpUmQBXUNhkc9kMsSIGM8ea2SzVgDQUy5+3ldNa
    YsZEtrBp/TvbVBb+TQ0biOLYBdLPpIpWDOdY0UZLLDd/qwrAvcG5eWM8CP862N6j
    B2zNH0d7shD2vMdH9ysGpxkGqEDb3orQ5so4lajO8SE+sWp2y/ul2VghW1424mx7
    rpG6Pd1L+aa8O4CJsCxegxOH3uBYkbf+y1Ey27jj2GY=
    =oIvW
    -----END PGP MESSAGE-----

    """
    keybase.verify signed, (err, info, output) ->
      assert.equal err, null
      assert.equal info.signer, 'you'
      done()

  it 'should reject an invalid message', (done) ->
    invalid = 'asd'
    keybase.verify invalid, (err, info, output) ->
      assert.notEqual err, null
      done()

  it 'should sign a message'
