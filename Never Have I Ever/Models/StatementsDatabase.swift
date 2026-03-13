//
//  StatementsDatabase.swift
//  Never Have I Ever
//
//  Created by Claude Code on 3/11/26.
//

import Foundation

/// Preloaded "Never Have I Ever" statements
struct StatementsDatabase {
    static let preloadedStatements: [Statement] = [
        // General
        Statement(text: "Never have I ever lied about my age", category: .general),
        Statement(text: "Never have I ever stalked someone on social media", category: .general),
        Statement(text: "Never have I ever pretended to be sick to get out of something", category: .general),
        Statement(text: "Never have I ever re-gifted a present", category: .general),
        Statement(text: "Never have I ever fallen asleep during a movie at the theater", category: .general),
        Statement(text: "Never have I ever sent a text to the wrong person", category: .general),
        Statement(text: "Never have I ever forgotten someone's name right after meeting them", category: .general),
        Statement(text: "Never have I ever cried during a kids movie", category: .general),
        Statement(text: "Never have I ever sung karaoke", category: .general),
        Statement(text: "Never have I ever danced in the rain", category: .general),
        
        // Wild
        Statement(text: "Never have I ever skinny dipped", category: .wild),
        Statement(text: "Never have I ever crashed a party", category: .wild),
        Statement(text: "Never have I ever been kicked out of a bar or club", category: .wild),
        Statement(text: "Never have I ever snuck out of the house", category: .wild),
        Statement(text: "Never have I ever told a secret I promised to keep", category: .wild),
        Statement(text: "Never have I ever gotten a tattoo on impulse", category: .wild),
        Statement(text: "Never have I ever pulled an all-nighter", category: .wild),
        Statement(text: "Never have I ever been in a fight", category: .wild),
        Statement(text: "Never have I ever dyed my hair a crazy color", category: .wild),
        Statement(text: "Never have I ever gone to work or school hungover", category: .wild),
        
        // Funny
        Statement(text: "Never have I ever laughed so hard I cried", category: .funny),
        Statement(text: "Never have I ever accidentally worn something inside out all day", category: .funny),
        Statement(text: "Never have I ever walked into a glass door", category: .funny),
        Statement(text: "Never have I ever tripped in public", category: .funny),
        Statement(text: "Never have I ever laughed at the wrong moment", category: .funny),
        Statement(text: "Never have I ever snorted while laughing", category: .funny),
        Statement(text: "Never have I ever waved at someone who wasn't waving at me", category: .funny),
        Statement(text: "Never have I ever accidentally liked an old photo while stalking", category: .funny),
        Statement(text: "Never have I ever pretended to know a song and sang the wrong lyrics", category: .funny),
        Statement(text: "Never have I ever held a door open for someone who was too far away", category: .funny),
        
        // Adventure
        Statement(text: "Never have I ever been skydiving", category: .adventure),
        Statement(text: "Never have I ever been bungee jumping", category: .adventure),
        Statement(text: "Never have I ever gone zip-lining", category: .adventure),
        Statement(text: "Never have I ever been scuba diving", category: .adventure),
        Statement(text: "Never have I ever climbed a mountain", category: .adventure),
        Statement(text: "Never have I ever been camping in the wilderness", category: .adventure),
        Statement(text: "Never have I ever ridden a motorcycle", category: .adventure),
        Statement(text: "Never have I ever gone white water rafting", category: .adventure),
        Statement(text: "Never have I ever been in a helicopter", category: .adventure),
        Statement(text: "Never have I ever gone surfing", category: .adventure),
        
        // Food
        Statement(text: "Never have I ever eaten food off the floor (5-second rule)", category: .food),
        Statement(text: "Never have I ever tried sushi", category: .food),
        Statement(text: "Never have I ever eaten an entire pizza by myself", category: .food),
        Statement(text: "Never have I ever cooked a meal that turned out completely wrong", category: .food),
        Statement(text: "Never have I ever eaten dessert before dinner", category: .food),
        Statement(text: "Never have I ever tried exotic food like insects", category: .food),
        Statement(text: "Never have I ever eaten at a Michelin star restaurant", category: .food),
        Statement(text: "Never have I ever burned water while cooking", category: .food),
        Statement(text: "Never have I ever eaten cereal for dinner", category: .food),
        Statement(text: "Never have I ever had food delivered past midnight", category: .food),
        
        // Travel
        Statement(text: "Never have I ever traveled to another continent", category: .travel),
        Statement(text: "Never have I ever been on a cruise", category: .travel),
        Statement(text: "Never have I ever missed a flight", category: .travel),
        Statement(text: "Never have I ever been to a music festival", category: .travel),
        Statement(text: "Never have I ever visited a famous landmark", category: .travel),
        Statement(text: "Never have I ever stayed in a 5-star hotel", category: .travel),
        Statement(text: "Never have I ever traveled alone", category: .travel),
        Statement(text: "Never have I ever been on a road trip", category: .travel),
        Statement(text: "Never have I ever slept in an airport", category: .travel),
        Statement(text: "Never have I ever visited more than 10 countries", category: .travel),
        
        // Spicy (AppStore-safe romantic/suggestive content)
        Statement(text: "Never have I ever kissed someone on the first date", category: .spicy),
        Statement(text: "Never have I ever had a secret crush on a friend", category: .spicy),
        Statement(text: "Never have I ever sent a flirty text to the wrong person", category: .spicy),
        Statement(text: "Never have I ever dated two people at the same time", category: .spicy),
        Statement(text: "Never have I ever had a summer fling", category: .spicy),
        Statement(text: "Never have I ever been on a blind date", category: .spicy),
        Statement(text: "Never have I ever kissed someone I just met", category: .spicy),
        Statement(text: "Never have I ever had a long-distance relationship", category: .spicy),
        Statement(text: "Never have I ever gone on a date with someone from a dating app", category: .spicy),
        Statement(text: "Never have I ever sent a love letter", category: .spicy),
        Statement(text: "Never have I ever had a romantic moment in the rain", category: .spicy),
        Statement(text: "Never have I ever danced with a stranger at a club", category: .spicy),
        Statement(text: "Never have I ever been caught making out", category: .spicy),
        Statement(text: "Never have I ever had a romantic picnic", category: .spicy),
        Statement(text: "Never have I ever slow danced with someone I liked", category: .spicy),
        Statement(text: "Never have I ever gone skinny dipping with someone", category: .spicy),
        Statement(text: "Never have I ever shared a hotel room with a date", category: .spicy),
        Statement(text: "Never have I ever had a romantic beach moment", category: .spicy),
        Statement(text: "Never have I ever kissed someone under the stars", category: .spicy),
        Statement(text: "Never have I ever gone to a couples retreat", category: .spicy)
    ]
}
