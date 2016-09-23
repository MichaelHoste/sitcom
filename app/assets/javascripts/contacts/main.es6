import BaseMain         from '../shared/base/base_main.es6'
import Contacts         from './index/contacts.es6'
import Contact          from './show/contact.es6'
import NewContact       from './shared/new_contact.es6'
import QuickSearch      from '../shared/quick_search.es6'
import AdvancedSearch   from './shared/advanced_search.es6'
import PermissionDenied from '../shared/permission_denied.es6'
import SavedSearches    from '../shared/saved_searches.es6'

class Main extends BaseMain {
  constructor(props) {
    super(props)

    this.itemType = 'contact'

    this.state = {
      contacts:         [],
      loaded:        false,
      selectedCount: 0,
    }
  }

  getFilters() {
    return {
      quickSearch:     this.props.location.query.quickSearch      || '',
      name:            this.props.location.query.name             || '',
      email:           this.props.location.query.email            || '',
      address:         this.props.location.query.address          || '',
      phone:           this.props.location.query.phone            || '',
      notes:           this.props.location.query.notes            || '',
      active:          this.props.location.query.active           || '',
      organizationIds: this.props.location.query.organizationIds,
      projectIds:      this.props.location.query.projectIds,
      eventIds:        this.props.location.query.eventIds,
      fieldIds:        this.props.location.query.fieldIds,
      tagIds:          this.props.location.query.tagIds,
    }
  }

  pushIdsListFilter(field, newId) {
    var filters = this.getFilters()
    var newIds

    if(filters[field] == undefined) {
      newIds = [newId]
    }
    else {
      newIds = _.map(filters[field].split(','), (id) => {
        return parseInt(id)
      })

      newIds = _.concat(newIds, newId)
    }

    var newFilters    = {}
    newFilters[field] = _.uniq(newIds).join(',')

    this.updateFilters(newFilters)
  }

  updateSelected(contact, newValue) {
    var index    = _.findIndex(this.state.contacts, (c) => { return contact.id == c.id})
    var contacts = this.state.contacts

    contacts[index].selected = newValue

    this.setState({
      contacts:      contacts,
      selectedCount: newValue ? this.state.selectedCount + 1 : this.state.selectedCount - 1
    })
  }

  render() {
    if(this.props.permissions.canReadContacts) {
      var filters = this.getFilters()

      return (
        <div className="container-fluid container-contact">
          <div className="row">
            <div className="col-md-4 pull-right right-sidebar">
              <SavedSearches router={this.props.router}
                             search={this.props.location.search}
                             itemType="contact"
                             savedSearchesPath={`${this.props.contactsPath}/saved_searches`} />

              <AdvancedSearch filters={filters}
                              updateFilters={this.updateFilters.bind(this)}
                              tagOptionsPath={this.props.tagOptionsPath}
                              fieldOptionsPath={this.props.fieldOptionsPath}
                              organizationOptionsPath={this.props.organizationOptionsPath}
                              projectOptionsPath={this.props.projectOptionsPath}
                              eventOptionsPath={this.props.eventOptionsPath} />
            </div>

            <div className="col-md-8 col-contacts">
              <QuickSearch title="Contacts"
                           loaded={this.state.loaded}
                           results={this.state.contacts.length}
                           selectedCount={this.state.selectedCount}
                           contacts={this.state.contacts}
                           tagOptionsPath={this.props.tagOptionsPath}
                           quickSearch={filters.quickSearch}
                           updateQuickSearch={this.updateQuickSearch.bind(this)}
                           reloadIndexFromBackend={this.reloadFromBackend.bind(this)}
                           filters={filters}
                           exportUrl={this.props.contactsPath + '/export'} />

              { this.renderNewButton("Nouveau contact") }

              { this.renderContact()  }
              { this.renderContacts() }
            </div>
          </div>

          { this.renderNewModal() }
        </div>
      )
    }
    else {
      return (
        <PermissionDenied />
      )
    }
  }

  renderContacts() {
    if(!this.props.params.id) {
      return (
        <Contacts permissions={this.props.permissions}
                  contacts={this.state.contacts}
                  loaded={this.state.loaded}
                  search={this.props.location.search}
                  tagOptionsPath={this.props.tagOptionsPath}
                  loadingImagePath={this.props.loadingImagePath}
                  updateSelected={this.updateSelected.bind(this)}
                  pushTagIdsFilter={this.pushIdsListFilter.bind(this, 'tagIds')}
                  pushFieldIdsFilter={this.pushIdsListFilter.bind(this, 'fieldIds')}
                  reloadIndexFromBackend={this.reloadFromBackend.bind(this)} />
      )
    }
  }

  renderContact() {
    if(this.props.params.id) {
      return (
        <Contact id={this.props.params.id}
                 permissions={this.props.permissions}
                 loaded={this.state.loaded}
                 contactsPath={this.props.contactsPath}
                 search={this.props.location.search}
                 loadingImagePath={this.props.loadingImagePath}
                 tagOptionsPath={this.props.tagOptionsPath}
                 fieldOptionsPath={this.props.fieldOptionsPath}
                 organizationOptionsPath={this.props.organizationOptionsPath}
                 projectOptionsPath={this.props.projectOptionsPath}
                 eventOptionsPath={this.props.eventOptionsPath}
                 contacts={this.state.contacts}
                 router={this.props.router}
                 reloadIndexFromBackend={this.reloadFromBackend.bind(this)} />
      )
    }
  }

  renderNewModal() {
    return (
      <NewContact reloadFromBackend={this.reloadFromBackend.bind(this)}
                  contactsPath={this.props.contactsPath}
                  router={this.props.router} />
    )
  }
}

module.exports = Main
