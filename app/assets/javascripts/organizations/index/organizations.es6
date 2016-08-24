import Organization from './organization.es6'

class Organizations extends React.Component {
  constructor(props) {
    super(props);

    this.state = {

    };
  }

  render() {
    return (
      <div className="organizations">
        { this.renderOrganizations() }
        { this.renderInfiniteLoading() }
      </div>
    )
  }

  renderOrganizations() {
    if(!this.props.loaded) {
      return (
        <div className="loading">
          <img src={this.props.loadingImagePath}/>
        </div>
      )
    }
    else if(this.props.organizations.length == 0) {
      return (
        <div className="blank-slate">
          Aucun résultat
        </div>
      )
    }
    else {
      return _.map(this.props.organizations, (organization) => {
        return (
          <Organization key={organization.id} organization={organization} search={this.props.search} />
        );
      });
    }
  }

  renderInfiniteLoading() {
    if(!this.props.infiniteLoaded && this.props.loaded) {
      return (
        <div className="loading">
          <img src={this.props.loadingImagePath}/>
        </div>
      );
    }
  }
}

module.exports = Organizations