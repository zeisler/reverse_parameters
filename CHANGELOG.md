## 1.0.0 - 2016-03-24

### API Changes
- ReverseParameters.new keyword arg :blocks_as_values moved to `ReverseParameters#arguments(blocks_as_values: [true, false])`

### Enhancement
- CoreExt to Ruby Code (Monkey Patch) `Method#reverse_parameters` and  `UnboundMethod#reverse_parameters`. This is not required by default, to use `require 'reverse_parameters/core_ext'`.

## 0.4.0 - 2016-03-14

### Enhancement
- Add the ability to pass blocks as values with the options blocks_as_values: true given in the initializer. 

## Initial 0.3.0
