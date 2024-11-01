//
//  AuthRepository.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 12/03/2024.
//

import Foundation
import RxSwift

protocol AuthRepository {
    func generatePartnerToken(phoneNumber: String, cif: String, name: String) -> Single<GenerateTokenPartnerResponseModel>
    func checkMemberAndConnection(phoneNumber: String, cif: String) -> Single<BaseResponseModel2<MemberConnectionDataModel>>
    func authenWithConnectedPhone(originalPhone: String, connectedPhone: String) -> Single<BaseResponseModel2<AuthConnectedPhoneDataModel>>
    func createMember(phoneNumber: String, cif: String, name: String) -> Single<BaseResponseModel2<MemberConnectionDataModel>>
    func getTermsOrPolicy(type: TermsAndPolicyType) -> Single<NewsResponseModel>
}
