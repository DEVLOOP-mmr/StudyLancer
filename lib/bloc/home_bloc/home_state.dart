enum LoadState { initial, loading, error, done }

abstract class HomeState {
  LoadState loadState = LoadState.initial;
  HomeState({
     this.loadState,
  });
}

class UnAuthenticatedHomeState extends HomeState {
  UnAuthenticatedHomeState() {
    loadState = LoadState.initial;
  }
}
