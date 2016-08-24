import Select from 'react-select'

class ItemsBlock extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      options: []
    };
  }

  componentDidMount() {
    this.reloadOptionsFromBackend()
  }

  reloadOptionsFromBackend() {
    $.get(this.props.optionsPath, (data) => {
      var camelData = humps.camelizeKeys(data);

      this.setState({
        options: camelData
      });
    });
  }

  removeItem(item) {
    if(confirm(this.props.removeConfirmMessage)) {
      var itemIds = _.filter(this.props.contact[this.props.fieldName], (itemId) => {
        return itemId != item.id;
      });

      this.saveOnBackend(itemIds);
    }
  }

  addItem(option) {
    this.saveOnBackend(
      _.uniq(_.concat(this.props.contact[this.props.fieldName], option.value))
    );
  }

  saveOnBackend(itemIds) {
    var params = {
      _method: 'PUT',
      contact: {}
    };

    params.contact[this.props.fieldName] = itemIds;

    $.post(this.props.contactPath, humps.decamelizeKeys(params), () => {
      this.props.reloadFromBackend();
    });
  }

  render() {
    return (
      <div className="items-block">
        <h3>{this.props.label} ({this.props.items.length})</h3>
        {this.renderItems()}
        {this.renderSelect()}
      </div>
    );
  }

  renderItems() {
    var itemDivs = _.map(this.props.items, (item) => {
      return this.renderItem(item);
    });

    return (
      <div className="row">
        {itemDivs}
      </div>
    )
  }

  renderItem(item) {
    return (
      <div className="col-md-6 item" key={item.id}>
        <img className="img-thumbnail" src={item.previewPictureUrl} />
        <h4>{item.name}</h4>

        <i className="fa fa-times remove-icon"
           onClick={this.removeItem.bind(this, item)}></i>

        {this.renderDates(item)}

        <span>
          <i className="fa fa-group"></i>
          {item.contactIds.length}
        </span>
      </div>
    )
  }

  renderDates(item) {
    if(this.props.fieldName == 'projectIds') {
      return (
        <span>{item.startDate} &rarr; {item.endDate}</span>
      );
    }

    if(this.props.fieldName == 'eventIds') {
      return (
        <span>{item.happensOn}</span>
      );
    }
  }

  renderSelect() {
    var filteredOptions = _.reject(this.state.options, (option) => {
      return _.includes(this.props.contact[this.props.fieldName], option.value);
    })

    return (
      <div className="select">
        <Select multi={false}
                options={filteredOptions}
                placeholder="Ajouter..."
                onChange={this.addItem.bind(this)} />
      </div>
    );
  }

}

module.exports = ItemsBlock
