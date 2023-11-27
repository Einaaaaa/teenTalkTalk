var event_service = require("../../services/event-service");

async function executeService(service, req, res, serviceName) {
    try {
      var result = await service(req, res);
      return result;
    } catch (error) {
      console.log(`code-controller ${serviceName} error: ${error}`);
    }
  }


  exports.fetchEventPart = (req, res) => executeService(event_service.fetchEventPart, req, res, 'fetchEventPart');
  
//   exports.fetchData = (req, res) => executeService(code_service.fetchData, req, res, 'fetchData');