# ManyWho Heroku Demo
This example shows how the ManyWho Gem can be used to run a flow within Ruby - on Heroku.  It's a basic
example - but hopefully provides a starting point for embedding ManyWho Flows into Heroku applications.

A running example can be found at: https://mighty-cliffs-6349.herokuapp.com

## How To Use This Demo
#### Information required to run a flow.

The *Tenant Id* is assigned when you register for your account on ManyWho. The easiest way to find out your *Tenant Id* is to log into the developer tooling - it's provided at the top right corner of the page.

The *Flow Id* is a unique identifier for your Flow.  The *Flow Id* does not change between versions of a Flow. The easiest way to find out your *Flow Id* is to "Activate" your Flow from the point-and-click Flow builder and grab the query string parameter for "flow-id".

The *Username* and *Password* contain the login details to log into a flow. These are optional and not all flows require them.

#### Running a flow
From the index page (which can be accessed using the above link) click the *Run a flow!* link, and enter the required fields (which can be found using the information above).
