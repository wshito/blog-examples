import * as React from 'react';
import * as ReactDOM from 'react-dom';

let Hello = React.createClass({
    render: function(){
      return <h1>Hello World!</h1>;
    }
  });

ReactDOM.render (<Hello />,
  document.getElementById('container'));
