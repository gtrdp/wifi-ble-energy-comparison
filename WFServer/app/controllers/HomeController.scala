package controllers

import javax.inject._
import play.api._
import play.api.mvc._

// imports for handling date
import java.util.Calendar
import java.util.Date
import java.text.SimpleDateFormat

/**
 * This controller creates an `Action` to handle HTTP requests to the
 * application's home page.
 */
@Singleton
class HomeController @Inject() extends Controller {

  /**
   * Create an Action to render an HTML page with a welcome message.
   * The configuration in the `routes` file means that this method
   * will be called when the application receives a `GET` request with
   * a path of `/`.
   */
  def index = Action {
    Ok(views.html.index("Your new application is ready."))
  }

  def postController = Action {
    val today = Calendar.getInstance().getTime()

    // create the date/time formatters
    val datetime = new SimpleDateFormat("yyyy-MM-dd HH.mm.ss")

    println("Received occupancy data: " + datetime.format(today))
    Ok("Data is stored!")
  }

  def getController = Action {
    Ok("This server only works with POST method.")
  }

}
