//
//  EventDetailsModel.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/22/22.
//

import Foundation

class BidInfoDetailsModel {
    
}

enum BidProgressStatus {
    case isPending
    case isInProgress
    case isCompleted
}
struct BidStatus {
    var title: String
    var subTitle: String?
    var status: BiddingStatus
    var progressStatus: BidProgressStatus
}

struct ServiceDetail {
    var title: String
    var subTitle: String
    var isCompleted: Bool
}

struct EventServiceDescDTO: Codable {
    var leadPeriod: Int
    var biddingCutOffDate: String
    var serviceDate: String
    var preferredSlots: [String]
    var serviceName: String?
    var estimatedBudget: String
    var currencyType: String?
    var zipCode: String
    var radius: String
    
    
    
    enum ServiceDateDTO: String, CodingKey {
            case leadPeriod, biddingCutOffDate, serviceDate, preferredSlots
    }
    
    enum EventBudgetDTO: String, CodingKey {
        case estimatedBudget, currencyType
    }
    
    enum EventVenueDTO: String, CodingKey {
        case zipCode, radius = "redius"
    }
    
    enum RootKeys: String, CodingKey {
            case eventServiceDateDto, eventServiceBudgetDto, eventServiceVenueDto
        }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        
        let serviceDateDTO = try container.nestedContainer(keyedBy: ServiceDateDTO.self, forKey: .eventServiceDateDto)
        
        leadPeriod = try serviceDateDTO.decode(Int.self, forKey: .leadPeriod)
        biddingCutOffDate = try serviceDateDTO.decode(String.self, forKey: .biddingCutOffDate)
        serviceDate = try serviceDateDTO.decode(String.self, forKey: .serviceDate)
        preferredSlots = try serviceDateDTO.decode([String].self, forKey: .preferredSlots)
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["12am - 4am", "11am - 2pm", "02pm - 05pm"])
        preferredSlots.append(contentsOf: ["My Time - Your Time"])

        let eventBudgetDTO = try container.nestedContainer(keyedBy: EventBudgetDTO.self, forKey: .eventServiceBudgetDto)
        estimatedBudget = try eventBudgetDTO.decode(String.self, forKey: .estimatedBudget)
        currencyType = try? eventBudgetDTO.decode(String?.self, forKey: .currencyType)
        
        let venueDTO = try container.nestedContainer(keyedBy: EventVenueDTO.self, forKey: .eventServiceVenueDto)
        zipCode = try venueDTO.decode(String.self, forKey: .zipCode)
        radius = try venueDTO.decode(String.self, forKey: .radius)
    }
}

struct QuestionareWrapperDTO: Codable {
    var eventServiceId: Int
    var eventServiceDescriptionId: Int
    var eventServiceStatus: String
    var eventServiceDescriptionDto: EventServiceDescDTO
    var questionnaireWrapperDto: QuestionareDto
    
    var venueAddress: VenueAddress?
    
    enum CodingKeys: String, CodingKey {
        case eventServiceId, eventServiceDescriptionId, eventServiceStatus, eventServiceDescriptionDto, questionnaireWrapperDto
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        eventServiceId = try container.decode(Int.self, forKey: .eventServiceId)
        eventServiceDescriptionId = try container.decode(Int.self, forKey: .eventServiceDescriptionId)
        eventServiceStatus = try container.decode(String.self, forKey: .eventServiceStatus)
        eventServiceDescriptionDto = try container.decode(EventServiceDescDTO.self, forKey: .eventServiceDescriptionDto)
        questionnaireWrapperDto = try container.decode(QuestionareDto.self, forKey: .questionnaireWrapperDto)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(eventServiceId, forKey: .eventServiceId)
        try container.encode(eventServiceDescriptionId, forKey: .eventServiceDescriptionId)
        try container.encode(eventServiceStatus, forKey: .eventServiceStatus)
        try container.encode(questionnaireWrapperDto, forKey: .questionnaireWrapperDto)
    }
}

struct QuestionareDto: Codable {
    var noOfVendors: Int
    var noOfEventOrganizers: Int
    var questionnaireDtos: [QuestionAns]
    
    enum CodingKeys: String, CodingKey {
        case noOfVendors, noOfEventOrganizers, questionnaireDtos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        noOfVendors = try container.decode(Int.self, forKey: .noOfVendors)
        noOfEventOrganizers = try container.decode(Int.self, forKey: .noOfEventOrganizers)
        questionnaireDtos = try container.decode([QuestionAns].self, forKey: .questionnaireDtos)
    }
}

struct QuestionAns: Codable {
    var id: Int
    var serviceCategoryId: Int
    var eventTemplateId: Int
    var questionMetadata: QuestionMetaData
    var active: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, serviceCategoryId, eventTemplateId, questionMetadata, active
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        serviceCategoryId = try container.decode(Int.self, forKey: .serviceCategoryId)
        eventTemplateId = try container.decode(Int.self, forKey: .eventTemplateId)
        questionMetadata = try container.decode(QuestionMetaData.self, forKey: .questionMetadata)
        active = try container.decode(Bool.self, forKey: .active)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
                
        try container.encode(id, forKey: .id)
        try container.encode(serviceCategoryId, forKey: .serviceCategoryId)
        try container.encode(eventTemplateId, forKey: .eventTemplateId)
        try container.encode(questionMetadata, forKey: .questionMetadata)
        try container.encode(active, forKey: .active)
    }
}

struct QuestionMetaData: Codable {
    var question: String
    var questionType: String
    var choices: [String]
    var eventOrganizer: Bool?
    var vendor: Bool?
    var filter: Bool?
    var answer: String
    
    enum CodingKeys: String, CodingKey {
        case question, questionType, choices, eventOrganizer, vendor, filter, answer
    }

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        question = try container.decode(String.self, forKey: .question)
        questionType = try container.decode(String.self, forKey: .questionType)
        choices = try container.decode([String].self, forKey: .choices)
        answer = try container.decode(String.self, forKey: .answer)
        
        var organizer: Bool? = try? container.decode(Bool.self, forKey: .eventOrganizer)
        if organizer == nil {
            if let stringVal = try? container.decode(String.self, forKey: .eventOrganizer) {
                organizer = stringVal == "true"
            }
        }
        
        var vendorBool: Bool? = try? container.decode(Bool.self, forKey: .vendor)
        if vendorBool == nil {
            if let stringVal = try? container.decode(String.self, forKey: .vendor) {
                vendorBool = stringVal == "true"
            }
        }
        
        var filterBool: Bool? = try? container.decode(Bool.self, forKey: .filter)
        if filterBool == nil {
            if let stringVal = try? container.decode(String.self, forKey: .filter) {
                filterBool = stringVal == "true"
            }
        }
        
        eventOrganizer = organizer
        vendor = vendorBool
        filter = filterBool
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(question, forKey: .question)
        try container.encode(questionType, forKey: .questionType)
        try container.encode(choices, forKey: .choices)
        try container.encode(eventOrganizer, forKey: .eventOrganizer)
        try container.encode(vendor, forKey: .vendor)
        try container.encode(filter, forKey: .filter)
        try container.encode(answer, forKey: .answer)
    }
}

struct EventDetail {
    var title: String
    var value: String
}

