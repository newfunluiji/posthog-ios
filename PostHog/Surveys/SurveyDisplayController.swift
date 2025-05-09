//
//  SurveyDisplayController.swift
//  PostHog
//
//  Created by Ioannis Josephides on 07/03/2025.
//

#if os(iOS)
    import SwiftUI

    final class SurveyDisplayController: ObservableObject {
        typealias SurveyShownHandler = (_ survey: PostHogSurvey) -> Void
        typealias SurveyResponseHandler = (_ survey: PostHogSurvey, _ responses: [String: PostHogSurveyResponse], _ completed: Bool) -> Void
        typealias SurveyClosedHandler = (_ survey: PostHogSurvey, _ completed: Bool) -> Void

        @Published var displayedSurvey: PostHogSurvey?
        @Published var isSurveyCompleted: Bool = false
        @Published var currentQuestionIndex: Int?
        private var questionResponses: [String: PostHogSurveyResponse] = [:]

        private let onSurveyShown: SurveyShownHandler
        private let onSurveyResponse: SurveyResponseHandler
        private let onSurveyClosed: SurveyClosedHandler

        private let kSurveyResponseKey = "$survey_response"

        init(
            onSurveyShown: @escaping SurveyShownHandler,
            onSurveyResponse: @escaping SurveyResponseHandler,
            onSurveyClosed: @escaping SurveyClosedHandler
        ) {
            self.onSurveyShown = onSurveyShown
            self.onSurveyResponse = onSurveyResponse
            self.onSurveyClosed = onSurveyClosed
        }

        func showSurvey(_ survey: PostHogSurvey) {
            guard displayedSurvey == nil else {
                hedgeLog("Already displaying a survey. Skipping")
                return
            }

            displayedSurvey = survey
            isSurveyCompleted = false
            currentQuestionIndex = 0
            onSurveyShown(survey)
        }

        func onNextQuestion(index: Int, response: PostHogSurveyResponse) {
            guard let displayedSurvey else { return }

            // update question responses
            let responseKey = index == 0 ? kSurveyResponseKey : "\(kSurveyResponseKey)_\(index)"
            questionResponses[responseKey] = response
            // move to next step
            currentQuestionIndex = getNextSurveyStep(survey: displayedSurvey, currentQuestionIndex: index)
            // record survey response
            isSurveyCompleted = isSurveyCompleted(survey: displayedSurvey, currentQuestionIndex: index)
            onSurveyResponse(displayedSurvey, questionResponses, isSurveyCompleted)
        }

        // User dismissed survey
        func dismissSurvey() {
            if let survey = displayedSurvey {
                onSurveyClosed(survey, isSurveyCompleted)
            }
            displayedSurvey = nil
            isSurveyCompleted = false
            currentQuestionIndex = nil
            questionResponses = [:]
        }

        func canShowNextSurvey() -> Bool {
            displayedSurvey == nil
        }

        private func getNextSurveyStep(
            survey: PostHogSurvey,
            currentQuestionIndex: Int
        ) -> Int {
            // TODO: Conditional questions
            min(currentQuestionIndex + 1, survey.questions.count - 1)
        }

        private func isSurveyCompleted(
            survey: PostHogSurvey,
            currentQuestionIndex: Int
        ) -> Bool {
            // TODO: Conditional questions
            currentQuestionIndex == survey.questions.count - 1
        }
    }
#endif
