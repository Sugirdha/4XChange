# 4XChange
Cool currency converter with a simple interface for easy customization and quick implementation. 

###### Note: scroll down for API information

### Version 2
Ver2 has seen a complete interface change and sports drop down menus with search bars so users can find their currency faster. The menus are a result of the external framework using Cocoapods. 


![](4XChange/4XChange-ver2-demo1.1.gif)


### Version 1
Ver1 comes with 2 original iOS picker views. 


![](4XChange/4XChange-ver1-demo1.1.gif)

### API Information
The exchange rates are pulled from exchangerates-api and parsed to convert 2 currencies when passed in a function call. You will need to use your own API key in the place of \(Keys.apiKey) in XChangeManager.swift while generating url for the request.
