assert = require 'assert'
keybase = require '../lib/keybase.coffee'

describe 'keybase', ->
  @timeout 10000
  target_signer = 'you'
  signed = {}
  signed.sgentle = """
  -----BEGIN PGP MESSAGE-----
  Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
  Comment: GPGTools - https://gpgtools.org

  owEBQwG8/pANAwAKAVViuAC+EL5tAcsTYgBTL/xzRG9uYWxkIEdsb3ZlcokBHAQA
  AQoABgUCUy/8cwAKCRBVYrgAvhC+bcL5CAC8/JOdtVUCTaoakkZ+QLVFlQ3p+RwR
  2qFu/N/7AtEawcH/4FPHD5VANCyuyx+WWF4AcoRW26ZoWbqv4sCwPIzLcURm4MeJ
  12zuveYGDWOgoCc+v5AWXh06FdjhMuVU6Qh9nbEK+Ei8DrvNyx3SfkNz8UGmef1Y
  tlf1sgnhFGY0xKsoua8ACZhMP4/ZL0kmpJwBNBeg8Mqi/+Gr5XsxkxJn7pb3+2r3
  zzzF6XznB/RS/ZoTn6X8qmLWr/SuUvzURJMIXdfzVv62m4b8zN9YDb9pfDeBiEPv
  75b9TEJ13dN5yZNZBnxautV6bR3kMqyHT+p7fmSfFc6Us0tu6VbGNeSX
  =0cIv
  -----END PGP MESSAGE-----

  """

  signed.you = """
  -----BEGIN PGP MESSAGE-----
  Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
  Comment: GPGTools - https://gpgtools.org

  owEBQgG9/pANAwAKAQHsPMmEdS8iAcsTYgBTL/59RG9uYWxkIEdsb3ZlcokBGwQA
  AQoABgUCUy/+fQAKCRAB7DzJhHUvIm3gB/j7WD9pQeVlzXjaq2sRLOIZ96yi3Jej
  H99JD6YEjl+zz4Xj9G2qhJ4o1DXwECoXQ5AURa7+E85v7gWhEXlUdrfrHV8EXbwc
  fbmfmf0WjJuU205KguJhEsnMGeSCkrvGTxHapm9GhlmhQNjvWnID+ekuo5japPXf
  NoLi/lV7dfXWRs2mgBVnkYqhSNTBPqOwWMAwgUBiHGEV1VB4Qdmiim5nSZvJp6/h
  yooEaj1JsC5BctI21xhlaixIbK+pRbBt5Vb1aiiA5qMD37ITwfsxTxtSIH70ujs4
  eOSuoV2udZi8sRjMKWAV4JoaEcALg9ENWwYjQ7X1C419hK1VYPHMvL0=
  =riyd
  -----END PGP MESSAGE-----

  """

  it 'should verify a valid message', (done) ->
    keybase.verify signed[target_signer], (err, info, output) ->
      assert.equal err, null
      assert.equal info.signer, target_signer
      done()

  it 'should decode the correct message', (done) ->
    keybase.decrypt signed[target_signer], (err, info, output) ->
      assert.equal err, null
      assert.equal output, "Donald Glover\n"
      done()

  it 'should should also return the signer on a decoded message', (done) ->
    keybase.decrypt signed[target_signer], (err, info, output) ->
      assert.equal err, null
      assert.equal info.signer, target_signer
      done()

  it 'should reject an invalid message', (done) ->
    invalid = 'asd'
    keybase.verify invalid, (err, info, output) ->
      assert.notEqual err, null
      done()

  it 'should sign a message', (done) ->
    message = 'hai there'
    keybase.sign message, (err, info, output) ->
      keybase.decrypt output, (err, info, output) ->
        assert.equal info.signer, 'you'
        assert.equal output, 'hai there\n'
        done()
