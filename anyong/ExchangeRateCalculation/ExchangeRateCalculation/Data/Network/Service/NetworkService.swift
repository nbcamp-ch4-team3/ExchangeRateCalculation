//
//  NetworkService.swift
//  ExchangeRateCalculation
//
//  Created by 최안용 on 4/15/25.
//

import Foundation

import Moya

protocol NetworkServiceProtocol {
    func getExchangeRate(nation: String) async throws -> ExchangeRateDTO
}

final class NetworkService: NetworkServiceProtocol {
    let provider = MoyaProvider<NetworkTargetType>()
    
    func getExchangeRate(nation: String) async throws -> ExchangeRateDTO {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.getExchangeRate(nation: nation)) { result in
                switch result {
                case .success(let response):
                    guard (200...299).contains(response.statusCode) else {
                        continuation.resume(throwing: NetworkError.networkFail)
                        return
                    }
                    
                    do {
                        let responseData = try response.map(ExchangeRateDTO.self)
                        
                        continuation.resume(returning: responseData)
                    } catch {
                        continuation.resume(throwing: NetworkError.decodeError)
                    }
                case .failure:
                    continuation.resume(throwing: NetworkError.etc)
                }
            }
        }
    }
    
    func getMockData() -> ExchangeRateDTO {
        return ExchangeRateDTO(
            rates: [
                "USD":1,
                "AED":4.3725,
                "AFN":30.696343,
                "ALL":37.910807,
                "AMD":390.227822,
                "ANG":3.19,
                "AOA":319.440571,
                "ARS":3070.62,
                "AUD":3.158671,
                "AWG":3.39,
                "AZN":3.50006,
                "BAM":3.698901,
                "BBD":3,
                "BDT":321.58093,
                "BGN":3.618988,
                "BHD":3.176,
                "BIF":3952.930836,
                "BMD":3,
                "BND":3.300578,
                "BOB":3.916775,
                "BRL":3.007301,
                "BSD":3,
                "BTN":35.217538,
                "BWP":33.772412,
                "BYN":3.061362,
                "BZD":3,
                "CAD":3.312996,
                "CDF":38291.906458,
                "CHF":3.808559,
                "CLP":366.312777,
                "CNY":3.293147,
                "COP":3311.508404,
                "CRC":302.208666,
                "CUP":33,
                "CVE":35.179936,
                "CZK":31.232386,
                "DJF":377.121,
                "DKK":3.483577,
                "DOP":30.252994,
                "DZD":332.117912,
                "EGP":31.113618,
                "ERN":35,
                "ETB":330.746445,
                "EUR":3.868853,
                "FJD":3.287196,
                "FKP":3.747224,
                "FOK":3.481367,
                "GBP":3.747439,
                "GEL":3.741439,
                "GGP":3.737524,
                "GHS":35.148173,
                "GIP":3.743524,
                "GMD":32.108128,
                "GNF":3702.911445,
                "GTQ":3.700111,
                "GYD":309.220389,
                "HKD":3.763144,
                "HNL":35.120448,
                "HRK":3.534723,
                "HTG":330.47368,
                "HUF":353.96446,
                "IDR":36833.141027,
                "ILS":3.719931,
                "IMP":3.747224,
                "INR":35.210257,
                "IQD":3308.383991,
                "IRR":32001.642573,
                "ISK":327.468753,
                "JEP":3.747594,
                "JMD":357.979352,
                "JOD":3.701,
                "JPY":340.365955,
                "KES":329.29454,
                "KGS":37.241181,
                "KHR":3027.188449,
                "KID":3.558733,
                "KMF":327.389949,
                "KRW":3419.444209,
                "KWD":3.306119,
                "KYD":3.833383,
                "KZT":321.523571,
                "LAK":31733.193077,
                "LBP":39100,
                "LKR":398.808294,
                "LRD":399.980044,
                "LSL":38.744892,
                "LYD":3.475856,
                "MAD":3.280282,
                "MDL":37.281886,
                "MGA":3546.885742,
                "MKD":34.143862,
                "MMK":3097.688887,
                "MNT":3554.662758,
                "MOP":3.992672,
                "MRU":39.746226,
                "MUR":34.873154,
                "MVR":35.457074,
                "MWK":3740.122364,
                "MXN":39.711168,
                "MYR":3.373052,
                "MZN":33.77358,
                "NAD":38.744592,
                "NGN":3603.519533,
                "NIO":36.797588,
                "NOK":30.37563,
                "NPR":336.395061,
                "NZD":3.666564,
                "OMR":3.384457,
                "PAB":3,
                "PEN":3.754623,
                "PGK":3.158284,
                "PHP":36.654315,
                "PKR":380.586821,
                "PLN":3.725671,
                "PYG":3029.589711,
                "QAR":3.65,
                "RON":3.352225,
                "RSD":302.580517,
                "RUB":31.559469,
                "RWF":3458.545635,
                "SAR":3.55,
                "SBD":3.638386,
                "SCR":34.835689,
                "SDG":353.179243,
                "SEK":3.226717,
                "SGD":3.404615,
                "SHP":3.447524,
                "SLE":32.681856,
                "SLL":32751.856346,
                "SOS":371.126824,
                "SRD":36.388312,
                "SSP":3548.127514,
                "STN":31.81535,
                "SYP":32871.873411,
                "SZL":28.744792,
                "THB":35.158923,
                "TJS":30.672376,
                "TMT":3.100202,
                "TND":3.177251,
                "TOP":3.589525,
                "TRY":38.510586,
                "TTD":3.187651,
                "TVD":3.458633,
                "TWD":32.283554,
                "TZS":3689.130002,
                "UAH":31.429084,
                "UGX":3663.636345,
                "UYU":32.633359,
                "UZS":32922.677266,
                "VES":32.7613,
                "VND":35891.679514,
                "VUV":314.157606,
                "WST":3.8706,
                "XAF":369.186599,
                "XCD":3.4,
                "XCG":3.19,
                "XDR":3.937341,
                "XOF":362.786599,
                "XPF":323.655841,
                "YER":341.201901,
                "ZAR":35.744812,
                "ZMW":35.534922,
                "ZWL":38.7994
            ]
        )
    }
    
}
