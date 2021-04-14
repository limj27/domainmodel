struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    let amount: Int
    let currency: String
    init(amount startingAmount: Int, currency startingCurrency: String) {
        self.amount = startingAmount
        if startingCurrency == "USD" || startingCurrency == "GBP" || startingCurrency == "EUR" || startingCurrency == "CAN" {
            self.currency = startingCurrency
        } else {
            print("Wrong currency input, try again", startingCurrency)
            self.currency = "ERR"
        }
    }
    func convert(_ curr: String) -> Money {
        if currency == "ERR" {
            print("Current currency is not valid")
            return Money(amount: amount, currency: currency)
        } else {
            if currency == "USD" {
                if curr == "GBP" {
                    let newAmount = Double(amount) * 0.5
                    return Money(amount: Int(newAmount.rounded()), currency: curr)
                } else if curr == "EUR" {
                    let newAmount = Double(amount) * 1.5
                    return Money(amount: Int(newAmount.rounded()), currency: curr)
                } else if curr == "CAN" {
                    let newAmount = Double(amount) * 1.25
                    return Money(amount: Int(newAmount.rounded()), currency: curr)
                }
            } else if currency == "GBP" {
                if curr == "USD" {
                    let newAmount = Double(amount) * 2
                    return Money(amount: Int(newAmount.rounded()), currency: curr)
                } else if curr == "EUR" {
                    let newAmount = Double(amount) * 3
                    return Money(amount: Int(newAmount.rounded()), currency: curr)
                } else if curr == "CAN" {
                    let newAmount = Double(amount) * 2.5
                    return Money(amount: Int(newAmount.rounded()), currency: curr)
                }
            } else if currency == "EUR" {
                if curr == "USD" {
                    let newAmount = Double(amount) * 0.66
                    return Money(amount: Int(newAmount.rounded()), currency: curr)
                } else if curr == "EUR" {
                    let newAmount = Double(amount) * 0.33
                    return Money(amount: Int(newAmount.rounded()), currency: curr)
                } else if curr == "CAN" {
                    let newAmount = Double(amount) * 0.83
                    return Money(amount: Int(newAmount.rounded()), currency: curr)
                }
            } else if currency == "CAN" {
                if curr == "USD" {
                    let newAmount = Double(amount) * 0.8
                    return Money(amount: Int(newAmount.rounded()), currency: curr)
                } else if curr == "EUR" {
                    let newAmount = Double(amount) * 1.2
                    return Money(amount: Int(newAmount.rounded()), currency: curr)
                } else if curr == "GBP" {
                    let newAmount = Double(amount) * 0.2
                    return Money(amount: Int(newAmount.rounded()), currency: curr)
                }
            }
        }
        return Money(amount: amount, currency: currency)
    }
    func add(_ money: Money) -> Money {
        let convertMoney = self.convert(money.currency)
        let newMoney = Money(amount: convertMoney.amount + money.amount, currency: money.currency)
        return newMoney
    }
    func subtract(_ money: Money) -> Money {
        let convertMoney = self.convert(money.currency)
        let newMoney = Money(amount: convertMoney.amount - money.amount, currency: money.currency)
        return newMoney
    }
}

////////////////////////////////////
// Job
//
public class Job {
    let title: String
    var type: JobType
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    init(title jobTitle: String, type jobType: JobType) {
        title = jobTitle
        type = jobType
    }
    func calculateIncome(_ hours: Int) -> Int {
        if case let .Salary(i) = type {
            return Int(i)
        }
        if case let .Hourly(j) = type {
            return Int(j * Double(hours))
        }
        return 0
    }
    func raise(byAmount x: Int) {
        if case let .Salary(i) = type {
            type = Job.JobType.Salary(i + UInt(x))
        }
        if case let .Hourly(j) = type {
            type = Job.JobType.Hourly(j + Double(x))
        }
    }
    func raise(byAmount x: Double) {
        if case let .Salary(i) = type {
            type = Job.JobType.Salary(i + UInt(x))
        }
        if case let .Hourly(j) = type {
            type = Job.JobType.Hourly(j + Double(x))
        }
    }
    func raise(byPercent x: Double) {
        if case let .Salary(i) = type {
            let total = Double(i) * x
            type = Job.JobType.Salary(i + UInt(total))
        }
        if case let .Hourly(j) = type {
            let total = j * x
            type = Job.JobType.Hourly(j + total)
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    let firstName: String
    let lastName: String
    let age: Int
    var job: Job? = nil {
        didSet(myNewValue) {
            if age < 21 {
                job = nil
            }
        }
    }
    var spouse: Person? = nil{
        didSet(myNewValue) {
            if age < 21 {
                spouse = nil
            }
        }
    }
    init(firstName first: String, lastName last: String, age personage: Int) {
        firstName = first
        lastName = last
        age = personage
    }
    
    func toString() -> String{
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: job?.type)) spouse:\(String(describing: spouse?.firstName))]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person] = []
    init(spouse1 sp1: Person, spouse2 sp2: Person) {
        if sp1.spouse == nil && sp2.spouse == nil {
            sp1.spouse = sp2
            sp2.spouse = sp1
        }
        members.append(sp1)
        members.append(sp2)
    }
    func haveChild(_ kid: Person) -> Bool{
        var minor = true
        for parent in members {
            if parent.age > 21 {
                minor = false
            }
        }
        if minor {
            return false
        } else {
            members.append(kid)
            return true
        }
    }
    func householdIncome() -> Int {
        var total = 0
        for person in members {
            if person.job != nil {
                total += (person.job?.calculateIncome(2000))!
            }
        }
        return total
    }
}
