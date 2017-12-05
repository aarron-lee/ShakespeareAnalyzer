import React from 'react';
import ReactDOM from 'react-dom';
import Root from './components/root';

document.addEventListener("DOMContentLoaded", function(){

  const root = document.getElementById('mount-point');

  ReactDOM.render(<Root/>, root);

});
