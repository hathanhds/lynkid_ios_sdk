//
//  UsersRepository.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 02/02/2024.
//

import RxSwift

protocol UserRepository {
    func getMemberView() -> Single<MemberViewResponseModel>
    func getUserPoint() -> Single<BaseResponseModel2<UserPointResponseModel>>
    func getLocation(request: LocationRequestModel) -> Single<BaseResponseModel<LocationResponseModel>>
    func getMemberVpbankInfor() -> Single<VpbankMemberInforResponseModel>
}
