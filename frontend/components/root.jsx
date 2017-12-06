import React from 'react';


class Root extends React.Component{

  constructor(){
    super();
    this.state = {
      play_name: 'macbeth',
      play_characters: [],
      errors: '',
      loading: false
    };
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(e){
    this.setState({play_name: e.target.value, errors: ''});
  }

  handleSubmit(e){
    e.preventDefault();

    this.refs['disable-target'].setAttribute("disabled", "disabled");

    let root = this;
    let handleSuccess = (payload) =>{
      root.refs['disable-target'].removeAttribute("disabled");
      if(payload && payload.length){
        root.setState({play_characters: payload, errors: '', loading: false})
      }
    };
    let handleFailure = (payload) =>{
      root.refs['disable-target'].removeAttribute("disabled");
      root.setState({errors: payload.responseJSON.errors, play_characters: [], loading: false})
    }

    let queryString = "?play_name=" + this.state.play_name;

    $.ajax({
        method: 'get',
        url: `/api/characters${queryString}`
    }).then(
      handleSuccess,
      handleFailure);

    this.setState({play_characters: [], loading: true, errors: ''});

  }

  render(){
    let characterComponents = this.state['play_characters'].map((character)=>{
      return (<li key={character.name}>{character.name} - {character.line_count} lines</li>)
    });

    let loadingSpinner = undefined;
    if(this.state.loading){
      loadingSpinner = (<div className="loader">Loading...</div>);
    }

    let errorMessages = undefined;
    if(this.state.errors.length > 0){
      errorMessages = (<div className="errors">Error: {this.state.errors}</div>)
    }

    return (<div className="app-container">
              <h1>Shakespeare Analyzer</h1>
              {errorMessages}
              <div className="form-container">
                <form onSubmit={this.handleSubmit}>
                  <h2>Select a Play to parse:</h2><br/>
                  <select value={this.state.play_name} onChange={this.handleChange}>
                    <option value="macbeth">Macbeth</option>
                    <option value="othello">Othello</option>
                    <option value="hamlet">Hamlet</option>
                    <option value="dream">A Midsummer Night's Dream</option>
                    <option value="j_caesar">Julius Caesar</option>
                    <option value="pericles">Pericles</option>
                    <option value="r_and_j">Romeo and Juliet</option>
                    <option value="win_tale">A Winter's Tale</option>
                  </select>
                  <button ref="disable-target">Submit</button>
                </form>
              </div>
              <ul className="character-list">
                {characterComponents}
              </ul>
              {loadingSpinner}
            </div>
          );
  }


}

export default Root;
