import Project from './project.es6'

class Projects extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      infiniteScrollOffset: 200
    };
  }

  componentDidMount() {
    this.bindInfiniteScroll();
  }

  componentWillMount() {
    this.unbindInfiniteScroll();
  }

  bindInfiniteScroll() {
    $(window).scroll(() => {
      if(this.props.infiniteLoaded && this.props.infiniteEnabled && this.props.loaded) {
        if($(window).scrollTop() + $(window).height() >= $(document).height() - this.state.infiniteScrollOffset) {
          this.props.loadNextBatchFromBackend();
        }
      }
    })
  }

  unbindInfiniteScroll() {
    $(window).unbind('scroll');
  }

  render() {
    return (
      <div className="projects">
        { this.renderProjects() }
        { this.renderInfiniteLoading() }
      </div>
    )
  }

  renderProjects() {
    if(!this.props.loaded) {
      return (
        <div className="loading">
          <img src={this.props.loadingImagePath}/>
        </div>
      )
    }
    else if(this.props.projects.length == 0) {
      return (
        <div className="blank-slate">
          Aucun résultat
        </div>
      )
    }
    else {
      return _.map(this.props.projects, (project) => {
        return (
          <Project key={project.id} project={project} search={this.props.search} />
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

module.exports = Projects
