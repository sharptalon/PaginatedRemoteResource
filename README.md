PaginatedRemoteResource
=======================

This sample app demonstrates techniques for interacting with a remote resource that exposes large lists of data via a paginated interface.

Interacting with the resource is abstracted through the `PaginatedRemoteResource` protocol, which fetches data based on an offset into the paginated list, and a limit on the maximum number of elements to be fetched. It is assumed that this data is returned in the form of an array of fetched items, accompanied by an integer value representing the total number of items available from the remote resource.

Two mock implementations of this protocol are provided, representing the fetching of a top-level set of parent items, and the fetching of parent-specific child objects, respectively.

The mock implementations are merely generating and returning local data, but they each support the specification of a delay parameter which is used to simulate the time required to request and parse data being requested from a remote network endpoint.

A shared base class for the table view controllers, named `RemoteResourceItemTableViewController`, takes care of fetching data from the resource endpoint, as well as caching it locally. In addition, as the user scrolls through the corresponding table views, this class takes care of automatically fetching any missing data and updating the table view once it is available.

