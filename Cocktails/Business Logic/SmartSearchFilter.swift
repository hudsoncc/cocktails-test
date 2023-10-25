//
//  SmartSearchFilter.swift
//  Cocktails
//
//  Created by Hudson Maul on 24/10/2023.
//
//  A search algorithm that helps quickly finds relevant matches by comparing each token in
//  a tokenised search query, against each token in a tokenised target string.
//
//  Based on https://github.com/hacknicity/SmartSearchExample

import Foundation

struct SmartSearchFilter {
    
    // MARK: Props (private)

    private var tokenisingCharacters: [String]!
    private var searchQueryTokens: [String.SubSequence]!
    private var compareOptions: String.CompareOptions!

    // MARK: Life cycle
    
    init(searchQuery: String, tokenisingCharacters: [String] = ["-", "."], 
         compareOptions: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]) {
        
        self.tokenisingCharacters = tokenisingCharacters
        self.compareOptions = compareOptions
        self.searchQueryTokens = tokenised(string: searchQuery, sortByDescendingLength: true)
    }
    
    // MARK: API (public)

    /// Check if the `searchQuery` and `targetString` match.
    func isMatch(for targetString: String) -> Bool {

        // 1. Treat no or an empty query as a match
        guard !searchQueryTokens.isEmpty else { return true }
        
        // 2. Tokenise the `targetString`
        var targetStringTokens = tokenised(string: targetString)

        // 3. Iterate over each search query token
        for searchToken in searchQueryTokens {

            var isMatchForSearchToken = false
            
            // 4. Iterate over each target string token
            for (targetStringTokenIndex, targetToken) in targetStringTokens.enumerated() {
                
                // 5. Check if `targetStringToken` starts with a `searchToken`...
                if isTokenMatch(forTarget: targetToken, andSearch: searchToken) {
                    
                    // 6. ...If so, flag the match and remove this `targetToken`
                    // so it can't be matched again
                    isMatchForSearchToken = true
                    targetStringTokens.remove(at: targetStringTokenIndex)
                    
                    // 7. Check the next search token
                    break
                }
            }
            
            // 8. At this point if this `searchToken` doesn't match any of the
            // target tokens, then there's no match!
            guard isMatchForSearchToken else { return false }
        }
        
        // 9. Otherwise every `searchToken` is a match for each target token, which
        // means `targetString` is a match!
        return true
    }
    
    // MARK: API (private)
    
    // Checks if a `targetToken` matches a `searchToken` via a [cd] comparison.
    private func isTokenMatch(forTarget targetToken: String.SubSequence,
                              andSearch searchToken: String.SubSequence) -> Bool {
        
        guard let range = targetToken.range(of: searchToken, options: compareOptions),
              range.lowerBound == targetToken.startIndex else {
            return false
        }
        return true
    }
    
    /**
     Splits the receiver into tokens separated by whitespace and optionally
     sorts the returned `String.SubSequence` by decreasing length.
     **/
    private func tokenised(string: String, sortByDescendingLength: Bool = false) -> [String.SubSequence] {
        var tokens = string.split(whereSeparator: {
            $0.isWhitespace || tokenisingCharacters.contains(String($0))
        })
        
        if sortByDescendingLength {
            tokens.sort { $0.count > $1.count }
        }
        return tokens
    }
    
}
