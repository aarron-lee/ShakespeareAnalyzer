import React from 'react';


class Root extends React.Component{

  constructor(){
    super();
    this.state = {
      play_name: 'macbeth',
      play_characters: [],
      errors: [],
    };
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(e){
    this.setState({play_name: e.target.value});
  }

  handleSubmit(e){
    e.preventDefault();

    let root = this;
    let handleSuccess = (payload) =>{
      if(payload && payload.length){
        root.setState({play_characters: payload, errors: []})
      }
    };
    let handleFailure = (payload) =>{
      root.setState({errors: [payload], play_characters: []})
    }

    let queryString = "?play_name=" + this.state.play_name;

    $.ajax({
        method: 'get',
        url: `/api/characters${queryString}`
    }).then(
      handleSuccess,
      handleFailure);

  }

  render(){
    let characterComponents = this.state['play_characters'].map((character)=>{
      return (<li key={character.name}>{character.name} - {character.line_count}</li>)
    });

    return (<div>
      <form onSubmit={this.handleSubmit}>
        <select value={this.state.play_name} onChange={this.handleChange}>
          <option value="macbeth">Macbeth</option>
          <option value="othello">Othello</option>
          <option value="hamlet">Hamlet</option>
          <option value="dream">A Midsummer Night's Dream</option>
        </select>
        <button>Submit</button>
      </form>
      <ul>
        {characterComponents}
      </ul>
    </div>);
  }


}

export default Root;