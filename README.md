[![Swift](https://github.com/JZDesign/Validation/actions/workflows/swift.yml/badge.svg?branch=main)](https://github.com/JZDesign/Validation/actions/workflows/swift.yml)


![Validation](https://github.com/user-attachments/assets/da87300a-f08f-4e82-97cc-a192494c00f8)

# Validation

Gather feedback on feature ideas so you can spend time working on what users actually want. 

## What is it?

One of the biggest issues I've seen over the years is the "I am not the user" cost. Stakeholders and engineers often suffer from thinking that something is valuable when it isn't, or the other way around. And—after they realize that—the company will often pay engineers to build fake doors to check the interest for a feature… many users feel lied to and disappointed when they go through a fake door.

—But—

What if there was a good, cheap, and honest way to ask your existing users what they think about an idea? What if they could tell you how interested they are without you needing to pay a designer and developers to create a "fake door" and risk damaging the user's trust?

> What if the ability to provide feedback on an upcoming feature *was* a **feature** of your application?

That's the goal of Validation. To provide a low-lift way to validate ideas before we spend too many hours working on something that is a flop.

## How does it work?

Validation is a UI as a Service. If you supply the URL to fetch the data from, we'll display it for you and make it easy to gather simple Positive, Negative feedback on your ideas. 

The body text handles simple markdown formatting:

- Bold
- Italics
- Links

And you can include an array of images to showcase what you're talking about.

The user can read through the content and provide a simple 👍 or 👎 to let you know what they think.

_Sample JSON payload [here.](Tests/ValidationTests/JSON/Sample.json) But for the best idea, checkout the [demo app.](DemoApp/DemoApp/ContentView.swift)_

### Options (Some examples… more to come)

#### You Host the JSON, handle the feedback, but we'll fetch and display it.

You can host a static JSON file anywhere you want that conforms to the `[NewFeatures]` interface. Provide the URL for an unauthenticated `GET` request for that endpoint and this package will display that data and allow you to ingest the feedback.

#### You have full control over all networking, leave the UI to us.

If you need authenticated endpoints, or you would rather load from local files on the device, you can create your own feature retriever and pass that in. As long as the data is returned and we can render it, you'll be able to ingest the feedback.

#### *Coming Soon* — Fully Hosted Saas (subscription required)

We'll provide an admin for you to add, modify, or delete new features for review. And we'll give you a nice dashboard on how many responses (positive or negative). You won't need to host any data, or handle the feedback.

See the TODO list below for a better idea on where we're at and what's coming up next

## What does it look like?

|Main Screen|Detail|With Images|
|:--:|:--:|:--:|
|![MainScreen](docs/img/Main_Screen.png)|![Content](docs/img/Content.png)|![withImage](docs/img/Content_Image.png)|


## TODO List

- [ ] Initial release
    - [x] UI
        - [x] Gather Feedback Screen
            - [x] Email?
            - [x] Feature List
        - [x] Detail Screen
    - [x] Simple repository with opinionated networking stack
    - [x] Handling feedback is sole responsibility of the consumer
    - [x] TESTS
        - [x] Unit
        - [x] Snapshot
    - [ ] Swagger Docs
    - [ ] Docs and examples (use static json to represent your features)
    - [x] Demo app
- [ ] Inject Configuration
    - [ ] Allow strings, images, tints, etc., to be injected for greater UI customization
- [ ] Save user responses locally
    - [ ] Show in the UI
    - [ ] Perform retries until success is received from the server
- [ ] Opinionated Handle Feedback
    - [ ] Can Handle feedback to a given URL
    - [ ] Swagger Docs
- [ ] On device cacheing
    - [ ] On device cache with load on network failure
    - [ ] Keep local record of feedback status and display that in the UI
- [ ] Saas
    - [ ] Allow consumers to subscribe to get an API key and use our own servers to host the data and accept the feedback.
    - [ ] A nice admin app to use with it
