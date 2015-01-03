goog = goog or goog = require: ->

goog.require 'spark.core.Store'


describe 'spark.core.Store', ->

  store = null

  beforeEach ->
    options =
      validations :
        firstName : required: yes, maxLength: 32, minLength: 2, alphabetic: yes
        lastName  : required: yes, maxLength: 32, minLength: 2, alphabetic: yes
        age       : numeric : yes
        email     : email   : yes
        userId    : length  : 8
        uniqueKey : equal   : 'unique', notEqual: 'notUnique'


    data =
      firstName   : 'Fatih'
      lastName    : 'Acet'
      age         : 27
      isMarried   : yes
      email       : 'acetfatih@gmail.com'
      userId      : '123ab678'
      uniqueKey   : 'unique'

    store = new spark.core.Store options, data


  it 'should extends spark.core.Object', ->
    expect(store instanceof spark.core.Object).toBeTruthy()


  it 'should have default options', ->
    s = new spark.core.Store null, null
    expect(s.getOptions()).toBeDefined()
    expect(s.map_).toBeDefined() if goog.debug


  it 'should create a goog.structs.Map with given data', ->
    if goog.structs?.Map
      expect(store.map_ instanceof goog.structs.Map).toBeTruthy()


  describe 'get', ->


    it 'should return the value of a given key', ->
      expect(store.get('firstName')).toBe 'Fatih'
      expect(store.get('lastName')).toBe 'Acet'
      expect(store.get('isMarried')).toBeTruthy()
      expect(store.get('age')).toBe 27


    it 'should return undefined for a non exists key', ->
      expect(store.get('realName')).not.toBeDefined()
      expect(store.get('realName')).toBeUndefined()


  describe 'set', ->


    it 'should set a key with value', ->
      store.set 'hasCar', no

      expect(store.get('hasCar')).toBeDefined()
      expect(store.get('hasCar')).toBeFalsy()


    it 'should not set a key without a value', ->
      store.set 'isDoctor'

      expect(store.get('isDoctor')).not.toBeDefined()


    it 'should validate the value', ->
      passed = 0
      failed = 0

      store.on 'PropertySet',      -> ++passed
      store.on 'PropertyRejected', -> ++failed

      store.set 'email', 'acet'
      expect(failed).toBe 1

      store.set 'firstName', 'Fatih Acet'
      expect(passed).toBe 1

      store.set 'age', 'acet'
      expect(failed).toBe 2

      store.set 'userId', '10ak10ak'
      expect(passed).toBe 2

      store.set 'isMarried', yes
      expect(passed).toBe 3


  it 'should remove a key from store', ->
    keysLength = store.getKeys().length

    expect(store.has('age')).toBeTruthy()

    store.unset('age')

    expect(store.has('age')).toBeFalsy()
    expect(store.getKeys().length + 1 is keysLength).toBeTruthy()


  it 'should remove all keys from store', ->
    expect(store.getKeys().length > 3).toBeTruthy()
    expect(store.get('firstName')).toBe 'Fatih'

    store.clear()

    expect(store.getKeys().length is 0).toBeTruthy()
    expect(store.get('firstName')).not.toBeDefined()


  it 'should return true if store has the given key', ->
    expect(store.has('firstName')).toBeTruthy()
    expect(store.has('lastName')).toBeTruthy()
    expect(store.has('hasCar')).toBeFalsy()


  it 'should return all keys', ->
    keys = store.getKeys()

    expect(keys.length > 3).toBeTruthy()
    expect(keys.indexOf('firstName') > -1).toBeTruthy()
    expect(keys.indexOf('isDoctor') is -1).toBeTruthy()


  it 'should return all values', ->
    values = store.getValues()

    expect(values.length > 3).toBeTruthy()
    expect(values.indexOf('Fatih') > -1).toBeTruthy()
    expect(values.indexOf('32') is -1).toBeTruthy()


  describe 'validate', ->


    it 'should return true when the given data is valid', ->
      expect(store.validate 'firstName', 'acet').toBeTruthy()
      expect(store.validate 'lastName', 'Fatih').toBeTruthy()
      expect(store.validate 'email', 'fatih@fatihacet.com').toBeTruthy()
      expect(store.validate 'age', 29).toBeTruthy()
      expect(store.validate 'age', '12').toBeTruthy()
      expect(store.validate 'userId', '911ef212').toBeTruthy()
      expect(store.validate 'uniqueKey', 'unique').toBeTruthy()


    it 'should return false when the given data is invalid', ->
      expect(store.validate 'firstName', '').toBeFalsy()
      expect(store.validate 'firstName', 'f').toBeFalsy()
      expect(store.validate 'firstName', 'f4t1h4c3t').toBeFalsy()
      expect(store.validate 'firstName', 'thisisverylongfirstnameitshouldnotvalid').toBeFalsy()
      expect(store.validate 'firstName', 23).toBeFalsy()

      expect(store.validate 'lastName', '').toBeFalsy()
      expect(store.validate 'lastName', 'a').toBeFalsy()
      expect(store.validate 'lastName', 'thisisverylonglastnameitshouldnotvalid').toBeFalsy()
      expect(store.validate 'lastName', 42).toBeFalsy()

      expect(store.validate 'age', '').toBeFalsy()
      expect(store.validate 'age', {}).toBeFalsy()
      expect(store.validate 'age', 'fatih').toBeFalsy()

      expect(store.validate 'email', '12').toBeFalsy()
      expect(store.validate 'email', 'fatih').toBeFalsy()
      expect(store.validate 'email', 'fatih@fatihacet').toBeFalsy()
      expect(store.validate 'email', '').toBeFalsy()

      expect(store.validate 'userId', '12').toBeFalsy()
      expect(store.validate 'userId', 'fatih').toBeFalsy()
      expect(store.validate 'userId', 123123123123).toBeFalsy()
      expect(store.validate 'userId', '').toBeFalsy()

      expect(store.validate 'uniqueKey', 'notUnique').toBeFalsy()
      expect(store.validate 'uniqueKey', 'notValid').toBeFalsy()


    it 'should assume the value is valid if there is not validation rule for it', ->
      expect(store.validate 'notExistKey', 'itdoesnotmatter').toBeTruthy()


    it 'should throw error when no validator found', ->
      error   = new Error 'Validation type foo does not exist.'
      options = validations: name: foo:  yes
      data    = name: 'Acetz'
      store   = new spark.core.Store options, data

      expect( -> store.validate('name', 'fatih')).toThrow error
