def Settings( **kwargs ):
  return {
    'flags': [
        '-g',
        '-pedantic',
        '-std=c++11',
        '-Wall',
        '-Wextra',
        '-Wshadow',
        '-Wnon-virtual-dtor',
        '-Woverloaded-virtual',
        '-Wold-style-cast',
        '-Wcast-align',
        '-Wuseless-cast',
        '-Wfloat-equal',
        '-fsanitize=address',
    ]
  }
