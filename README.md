#  HTTPeasy
![](https://img.shields.io/badge/platform-iOS10+-blue.svg) ![](https://img.shields.io/badge/Swift-5+-orange.svg) ![](https://img.shields.io/badge/coverage-94%25-green.svg)

## Description

HTTPeasy makes simple API requests easy to perform.

Nowadays most web APIs make use of JSON and a RESTful scheme, so HTTPeasy was created for these kind of simple scenarios, where you just want to fetch or update some data, using the most common standards.

HTTPeasy let's you simply declare how you want your request to be performed (the URL that should be used and which headers and parameters you want to pass on the request), and that's it. You get a completion handler back with your data, through an expressive API.

## Usage

### Installation

#### Carthage

In order to install HTTPeasy, all you need to do is add it as a dependency to your project's Cartfile.

```
github "pieromattos/HTTPeasy" ~> 1.0
```

If you're not familiar with Carthage, you can learn more about it [over here](https://github.com/Carthage/Carthage).

#### Swift Package Manager

To install HTTPeasy as a Swift package, just add it to your project using Xcode's file menu.

If you're not familiar with Swift Package Manager, you can learn more about it [over here](https://swift.org/package-manager/)

### API Documentation

All availabel classes, structs, and methods are document inline on the code. This means you can simply start typing the name of these entities and Xcode's autocomplete will help you discover the properties and methods that are available. You will be able to see a window like this:

![](https://github.com/pieromattos/HTTPeasy/blob/master/Docs/Images/Autocomplete.png)

Nonetheless, here are examples of how to use the framework to perform simple HTTP requests:

Let's say you want to fetch some JSON data from an endpoint, here's how you can do it using HTTPeasy:

``` swift
// First we create a request descriptor

let requestDescriptor = Request.Descriptor(.GET, "https://some_website/posts")

// Then we simply call .request on the APIRequester shared instance object to perform the request

APIRequester.shared.request(requestDescriptor) { data, error in

    // Do something with the data returned
    
    if let data = data {
        print(data)
    }
}
```

Let's say you want to update a post on the same website, you can do it like so: 

``` swift

// First we create a request descriptor

let paramsToUpdate = ["likes": 5]
let headers = ["auth_token": "some_token"]
let requestDescriptor = Request.Descriptor(.PUT, "https://some_website/posts/123", paramsToUpdate, headers)

// Then we simply call .request on the APIRequester shared instance object to perform the request

APIRequester.shared.request(requestDescriptor) { data, error in

    // Make sure the request was successful by checking if an error was returned

    if let error = error {
        print("An error occurred!")
    }
}
```

## Contributions and feedback

If you have contributions or feedback to provide regarding this project, please do so by contacing me at [piero@pmattos.com](mailto:piero@pmattos.com).

You can also find more information about me on my webstie at: [pmattos.com](https://pmattos.com).

