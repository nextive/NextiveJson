Nextive JSON 
================================

License
---------
This software is licensed under the MIT License. 

> Copyright (c) 2011 Nextive LLC

> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

We'd love to know if you're using this in your software, but it's not a requirement. 


Documentation
---------
There's some basic documentation on the <code>docs</code> directory, generated with [appledoc](https://github.com/tomaz/appledoc) (great software BTW). More will come with time. 


History
---------
When we started developing this parser, the available parsers (well, the ones we were aware of) were [TouchJSON](https://github.com/TouchCode/TouchJSON) and [SBJson](https://github.com/stig/json-framework/). Both were too slow for the task at hand. We needed to parse a pretty big (3 Mb+) file, so we decided (mostly as a learning exercise) to create our own. Our first attemp was comparable to SBJson, and a few optimizations later it became much faster. It's not the fastest parser around (currently the king of speed is [JSONKit](https://github.com/johnezang/JSONKit)) and it probably never will, but it's not too bad either. We're working on some optimizations trying to make it faster but not hard to understand.

Libraries
--------
We use the excelent [stringencoders](http://code.google.com/p/stringencod) library for wicked fast number to string conversions.