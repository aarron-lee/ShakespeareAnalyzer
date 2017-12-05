import React from 'react';


class Root extends React.Component{

  constructor(){
    super();
    this.state = {
      play_name: 'macbeth',
      play_characters: [],
    };
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(e){
    e.preventDefault();

    

  }

  render(){

    return (<div>React is working!</div>);

  }


}

export default Root;
