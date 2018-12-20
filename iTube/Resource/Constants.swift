//
//  Constant.swift
//  iTube
//
//  Created by Kamaluddin Khan on 15/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import Foundation
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let LOGINSTATUS = "LoginStatus"
let RELATED_CELL_IDENTIFIER = "RelatedVideoTableViewCell"
let TAB_VIEW_CONTROLLER_IDENTIFIER = "UserTabViewController"
let PLAYER_VIDEO_CONTROLLER_IDENTITY = "PlayerViewController"
let SERCH_VIEW_CONTROLLER_INDENTITY = "SearchResultTableViewController"
let CUSTOME_CELL_IDENTITY = "CustomeTableViewCell"
let SEARCH_TABLE_VIEW_CELL_IDENTITY = "SearchTableViewCell"
let NAVIGATION_CONTROLLER_IDENTITY = "UINavigationController"
let LOGIN_VIEW_CONTROLLER_IDENTITY = "LoginViewController"

let APP_NAME = "iTube"

let VIDEO_ID = "videoId"
let VIDEO_ENTITY_NAME = "Video"

let API_KEY = "AIzaSyAeNIWJeLqBOMcMJGWSA9MhMQKmZbnobOE"
let SEARCH_API_LINK_VIDEOS = "https://www.googleapis.com/youtube/v3/videos?"
let SEARCH_API_LINK_SEARCH = "https://www.googleapis.com/youtube/v3/search?"
let SEARCH_BAR_PLACEHOLDER = "Search iTube"

let headUrlForSearch = SEARCH_API_LINK_SEARCH + APIParameters.part.rawValue + SNIPPET + APIParameters.AND.rawValue
let headUrlForVideos = SEARCH_API_LINK_VIDEOS + APIParameters.part.rawValue + SNIPPET + APIParameters.AND.rawValue
let tailUrl = APIParameters.maxResults.rawValue + "7" + APIParameters.AND.rawValue + APIParameters.type.rawValue + TYPE + APIParameters.AND.rawValue + APIParameters.key.rawValue + API_KEY
let suggessionHeadUrl = "https://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q="
let suggessionTailUrl = "&format=5&alt=json&callback=?"
let LOCATION = "28.6139,77.2090"
let SNIPPET = "snippet"
let LOCATION_RADIUS = "100mi"
let Q = "surfing"
let TYPE = "video"
let REGION_CODE = "IN"
let MOST_POPULAR = "mostPopular"
let VIDEO_CATEGORY_ID = "10"

let NO_INTERNET = "No Internet"
let CONNECT_TO_NETWORK = "Connect to Network"
let INTERNET_CONNECTED = "Internet Connected "
let WITH_WIFI = "with Wifi"
let WITH_MOBILE_NETWORK = "with mobile network"

let OVERLAY_TABBED_NOTIFIER = "overlayViewTabbed"
let RELATED_VIDEO = "Related Video"


let DISSMISS_IMAGE_NAME = "dismiss"
let FAVOURITE_IMAGE_SELECTED = "favourite_icon"
let FAVOURITE_IMAGE_BLACK = "favourite_black"


let AUTHENTICATION_ERROR = "Authentication Error"
let ERROR_TITLE = "Error"

let SEARCH_HISTORY_KEY = "searchedKeywords"
let HISTORY_CLOCK_SYMBOL = "\u{1F553} "
